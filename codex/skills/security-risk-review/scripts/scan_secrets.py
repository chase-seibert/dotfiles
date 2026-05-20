#!/usr/bin/env python3
"""Conservative dependency-free secret scanner for Codex review workflows."""

from __future__ import annotations

import argparse
import json
import math
import os
import re
import sys
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable, Iterator


SKIP_DIRS = {
    ".cache",
    ".git",
    ".hg",
    ".mypy_cache",
    ".next",
    ".nuxt",
    ".pytest_cache",
    ".serverless",
    ".svn",
    ".terraform",
    ".venv",
    "__pycache__",
    "DerivedData",
    "Pods",
    "build",
    "coverage",
    "dist",
    "node_modules",
    "target",
    "vendor",
    "venv",
    "xcuserdata",
}

SKIP_EXTENSIONS = {
    ".7z",
    ".a",
    ".ai",
    ".bin",
    ".bmp",
    ".class",
    ".dmg",
    ".doc",
    ".docx",
    ".dylib",
    ".eot",
    ".exe",
    ".gif",
    ".gz",
    ".heic",
    ".icns",
    ".ico",
    ".jar",
    ".jpeg",
    ".jpg",
    ".lock",
    ".mov",
    ".mp3",
    ".mp4",
    ".o",
    ".otf",
    ".pdf",
    ".png",
    ".ppt",
    ".pptx",
    ".pyc",
    ".rar",
    ".so",
    ".sqlite",
    ".tar",
    ".tgz",
    ".ttf",
    ".webp",
    ".woff",
    ".woff2",
    ".xls",
    ".xlsx",
    ".zip",
}

MAX_FILE_BYTES = 2_000_000
TEXT_SAMPLE_BYTES = 4096


@dataclass(frozen=True)
class Finding:
    path: str
    line: int
    kind: str
    confidence: str
    secret: str
    context: str


@dataclass(frozen=True)
class PatternRule:
    kind: str
    regex: re.Pattern[str]
    confidence: str = "high"
    group: int = 1


PATTERN_RULES = [
    PatternRule(
        "private-key",
        re.compile(r"-----BEGIN ((?:RSA|DSA|EC|OPENSSH|PGP )?PRIVATE KEY)-----"),
        "high",
        0,
    ),
    PatternRule("openai-project-api-key", re.compile(r"\b(sk-proj-[A-Za-z0-9_-]{20,})\b")),
    PatternRule("openai-api-key", re.compile(r"\b(sk-(?!proj-)[A-Za-z0-9_-]{20,})\b")),
    PatternRule("github-token", re.compile(r"\b((?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9_]{20,})\b")),
    PatternRule("github-fine-grained-token", re.compile(r"\b(github_pat_[A-Za-z0-9_]{20,})\b")),
    PatternRule("slack-token", re.compile(r"\b(xox[abprs]-[A-Za-z0-9-]{20,})\b")),
    PatternRule(
        "slack-webhook-url",
        re.compile(r"\b(https://hooks\.slack\.com/services/[A-Za-z0-9/_-]{20,})\b"),
    ),
    PatternRule("aws-access-key-id", re.compile(r"\b((?:AKIA|ASIA)[A-Z0-9]{16})\b")),
]

GENERIC_ASSIGNMENT_RE = re.compile(
    r"""(?ix)
    \b
    [A-Za-z0-9_.-]*
    (?:api[_-]?key|auth[_-]?token|access[_-]?token|refresh[_-]?token|secret|client[_-]?secret|
       signing[_-]?key|private[_-]?key|password|passwd|pwd|credential|webhook)
    [A-Za-z0-9_.-]*
    \b
    \s*[:=]\s*
    (?P<quote>["']?)
    (?P<value>[A-Za-z0-9_./+=:@$%~-]{16,})
    (?P=quote)
    """
)

PLACEHOLDER_RE = re.compile(
    r"(?i)^(?:example|sample|dummy|fake|test|todo|changeme|change-me|your[_-].*|"
    r"<.*>|\$\{.*\}|xxx+|redacted|REDACTED|null|none|undefined)$"
)


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Scan files for likely hardcoded secrets without external dependencies."
    )
    parser.add_argument("paths", nargs="*", default=["."], help="Files or directories to scan.")
    parser.add_argument("--json", action="store_true", help="Emit JSON findings.")
    parser.add_argument(
        "--fail-on-findings",
        action="store_true",
        help="Exit with status 1 when findings are present.",
    )
    return parser.parse_args(argv)


def iter_files(paths: Iterable[str]) -> Iterator[Path]:
    for raw_path in paths:
        path = Path(raw_path)
        if not path.exists():
            print(f"warning: path not found: {raw_path}", file=sys.stderr)
            continue
        if path.is_file():
            if should_scan_file(path):
                yield path
            continue
        for root, dirnames, filenames in os.walk(path):
            dirnames[:] = [
                dirname
                for dirname in dirnames
                if dirname not in SKIP_DIRS and not dirname.startswith(".git")
            ]
            root_path = Path(root)
            for filename in filenames:
                candidate = root_path / filename
                if should_scan_file(candidate):
                    yield candidate


def should_scan_file(path: Path) -> bool:
    if any(part in SKIP_DIRS for part in path.parts):
        return False
    if path.suffix in SKIP_EXTENSIONS:
        return False
    try:
        if path.stat().st_size > MAX_FILE_BYTES:
            return False
        with path.open("rb") as handle:
            sample = handle.read(TEXT_SAMPLE_BYTES)
    except OSError:
        return False
    if b"\x00" in sample:
        return False
    return True


def scan_file(path: Path) -> list[Finding]:
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return []

    findings: list[Finding] = []
    for line_number, line in enumerate(text.splitlines(), start=1):
        findings.extend(scan_line(path, line_number, line))
    return findings


def scan_line(path: Path, line_number: int, line: str) -> list[Finding]:
    findings: list[Finding] = []
    occupied_spans: list[tuple[int, int]] = []
    for rule in PATTERN_RULES:
        for match in rule.regex.finditer(line):
            secret = match.group(rule.group)
            if is_placeholder(secret):
                continue
            occupied_spans.append(match.span(rule.group))
            findings.append(
                make_finding(path, line_number, rule.kind, rule.confidence, secret, line)
            )

    for match in GENERIC_ASSIGNMENT_RE.finditer(line):
        if overlaps_any(match.span("value"), occupied_spans):
            continue
        secret = match.group("value").strip()
        if is_placeholder(secret) or looks_like_url_without_secret(secret):
            continue
        entropy = shannon_entropy(secret)
        if entropy < 3.2 and not has_mixed_secret_charset(secret):
            continue
        confidence = "medium" if entropy >= 3.5 or has_mixed_secret_charset(secret) else "low"
        findings.append(
            make_finding(path, line_number, "generic-secret-assignment", confidence, secret, line)
        )
    return dedupe_findings(findings)


def overlaps_any(span: tuple[int, int], spans: Iterable[tuple[int, int]]) -> bool:
    start, end = span
    return any(start < other_end and other_start < end for other_start, other_end in spans)


def make_finding(
    path: Path, line_number: int, kind: str, confidence: str, secret: str, line: str
) -> Finding:
    return Finding(
        path=str(path),
        line=line_number,
        kind=kind,
        confidence=confidence,
        secret=mask_secret(secret),
        context=mask_context(line.strip(), secret),
    )


def dedupe_findings(findings: list[Finding]) -> list[Finding]:
    seen: set[tuple[str, int, str, str]] = set()
    unique: list[Finding] = []
    for finding in findings:
        key = (finding.path, finding.line, finding.kind, finding.secret)
        if key in seen:
            continue
        seen.add(key)
        unique.append(finding)
    return unique


def is_placeholder(value: str) -> bool:
    normalized = value.strip().strip("\"'")
    if PLACEHOLDER_RE.match(normalized):
        return True
    if len(set(normalized.lower())) <= 3:
        return True
    return False


def looks_like_url_without_secret(value: str) -> bool:
    if "://" not in value:
        return False
    lowered = value.lower()
    return not any(marker in lowered for marker in ("token", "key", "secret", "@"))


def has_mixed_secret_charset(value: str) -> bool:
    classes = 0
    classes += any(char.islower() for char in value)
    classes += any(char.isupper() for char in value)
    classes += any(char.isdigit() for char in value)
    classes += any(char in "_./+=:@$%~-" for char in value)
    return classes >= 3


def shannon_entropy(value: str) -> float:
    if not value:
        return 0.0
    counts = {char: value.count(char) for char in set(value)}
    return -sum((count / len(value)) * math.log2(count / len(value)) for count in counts.values())


def mask_secret(secret: str) -> str:
    if len(secret) <= 8:
        return "*" * len(secret)
    prefix = secret[:4]
    suffix = secret[-4:]
    return f"{prefix}...{suffix}"


def mask_context(line: str, secret: str) -> str:
    return line.replace(secret, mask_secret(secret))


def print_text(findings: list[Finding]) -> None:
    if not findings:
        print("No likely secrets found.")
        return
    for finding in findings:
        print(
            f"{finding.path}:{finding.line}: {finding.kind} "
            f"({finding.confidence}) {finding.secret}"
        )
        print(f"  {finding.context}")


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    findings: list[Finding] = []
    for path in iter_files(args.paths):
        findings.extend(scan_file(path))

    if args.json:
        print(json.dumps([asdict(finding) for finding in findings], indent=2))
    else:
        print_text(findings)

    if findings and args.fail_on_findings:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
