#!/usr/bin/env python3
"""Audit AGENTS.md files and their local reference graph."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Any
from urllib.parse import unquote, urlparse


MARKDOWN_LINK_RE = re.compile(r"!?\[[^\]]+\]\(([^)]+)\)")
LOAD_RE = re.compile(r"^\s*(?:[-*]\s*)?Load\s+(.+?)\s*$", re.IGNORECASE)
AT_REF_RE = re.compile(
    r"(?<![\w.-])@((?:~|/|\.{1,2}/)?[A-Za-z0-9_./-]+\.[A-Za-z0-9][A-Za-z0-9_-]{0,15})"
)
BACKTICK_PATH_RE = re.compile(r"`([^`]+)`")
URL_RE = re.compile(r"https?://[^\s)>\]\"']+")
REFERENCE_EXTENSIONS = {"", ".md", ".markdown", ".txt", ".rst", ".adoc", ".yaml", ".yml", ".toml"}
FILE_EXTENSION_RE = re.compile(r"\.[A-Za-z0-9][A-Za-z0-9_-]{0,15}$")
BINARY_SNIFF_BYTES = 4096


def safe_urlparse(value: str):
    try:
        return urlparse(value)
    except ValueError:
        return urlparse("")


def canonical(path: Path) -> str:
    try:
        return str(path.expanduser().resolve(strict=False))
    except (OSError, RuntimeError, ValueError):
        return str(path.expanduser().absolute())


def detect_project_root(start: Path) -> Path:
    expanded = start.expanduser()
    base = expanded.parent if expanded.is_file() else expanded
    try:
        result = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"],
            cwd=str(base),
            capture_output=True,
            text=True,
            check=False,
        )
    except OSError:
        result = None

    if result and result.returncode == 0 and result.stdout.strip():
        return Path(result.stdout.strip()).expanduser().resolve(strict=False)
    return base.resolve(strict=False)


def clean_target(raw: str) -> str:
    target = raw.strip()
    if not target:
        return ""
    if "\x00" in target:
        return ""

    if " " in target and not target.startswith(("\"", "'")):
        target = target.split()[0]

    target = target.strip().strip("`'\"<>")
    target = target.rstrip(".,;")

    parsed = safe_urlparse(target)
    if parsed.scheme and parsed.scheme != "file":
        return target

    if "#" in target:
        target = target.split("#", 1)[0]

    return unquote(target.strip())


def is_external(target: str) -> bool:
    parsed = safe_urlparse(target)
    return bool(parsed.scheme and parsed.scheme != "file")


def looks_like_local_reference(target: str) -> bool:
    if is_external(target):
        return True
    if target.startswith("#"):
        return False
    if target.startswith(("~", "./", "../")):
        return True
    if target.startswith("/"):
        return target.endswith("/") or target.count("/") >= 2
    return "/" in target or bool(FILE_EXTENSION_RE.search(target))


def resolve_local(target: str, source: Path) -> Path:
    if "\x00" in target:
        raise ValueError("embedded null byte in reference target")
    parsed = safe_urlparse(target)
    if parsed.scheme == "file":
        target = parsed.path

    if target == "~":
        path = Path.home()
    elif target.startswith("~/"):
        path = Path.home() / target[2:]
    elif target.startswith("~"):
        raise ValueError(f"cannot expand user home reference: {target}")
    else:
        path = Path(target)

    if path.is_absolute():
        return path.resolve(strict=False)
    return (source.parent / path).resolve(strict=False)


def add_ref(refs: list[dict[str, Any]], seen: set[tuple[int, str]], kind: str, raw: str, line: int) -> None:
    target = clean_target(raw)
    if not target or target.startswith("#"):
        return
    if kind != "url" and not looks_like_local_reference(target):
        return
    key = (line, target)
    if key in seen:
        return
    seen.add(key)
    refs.append({"kind": kind, "raw": raw.strip(), "target": target, "line": line})


def markdown_target(raw_inside_link: str) -> str:
    target = raw_inside_link.strip()
    if target.startswith("<") and ">" in target:
        return target[1 : target.index(">")]
    if " " in target:
        return target.split()[0].strip()
    return target


def extract_references(text: str) -> list[dict[str, Any]]:
    refs: list[dict[str, Any]] = []
    seen: set[tuple[int, str]] = set()

    for line_number, line in enumerate(text.splitlines(), start=1):
        for match in MARKDOWN_LINK_RE.finditer(line):
            add_ref(refs, seen, "markdown-link", markdown_target(match.group(1)), line_number)

        if "](" not in line:
            load_match = LOAD_RE.match(line)
            if load_match:
                add_ref(refs, seen, "load", load_match.group(1), line_number)

        for match in AT_REF_RE.finditer(line):
            add_ref(refs, seen, "at-reference", match.group(1), line_number)

        for match in BACKTICK_PATH_RE.finditer(line):
            candidate = match.group(1).strip()
            if candidate.startswith(("/", "~", "./", "../")):
                add_ref(refs, seen, "backtick-path", candidate, line_number)

        for match in URL_RE.finditer(line):
            add_ref(refs, seen, "url", match.group(0), line_number)

    return refs


def file_status(path: Path) -> str:
    try:
        if not path.exists():
            return "missing"
        if not path.is_file():
            return "not_file"
        if not os.access(path, os.R_OK):
            return "unreadable"
    except (OSError, RuntimeError, ValueError):
        return "invalid"
    return "readable"


def reference_scan_mode(path: Path) -> tuple[bool, str | None]:
    if path.suffix.lower() not in REFERENCE_EXTENSIONS:
        return False, "unsupported_extension"

    try:
        with path.open("rb") as handle:
            sample = handle.read(BINARY_SNIFF_BYTES)
    except OSError as exc:
        return False, f"sniff_failed: {exc}"

    if b"\x00" in sample:
        return False, "binary_file"
    return True, None


class Auditor:
    def __init__(self, max_depth: int) -> None:
        self.max_depth = max_depth
        self.nodes: dict[str, dict[str, Any]] = {}
        self.incoming: dict[str, list[dict[str, Any]]] = {}
        self.external_refs: list[dict[str, Any]] = []
        self.cycles: list[dict[str, Any]] = []
        self.skipped: list[dict[str, Any]] = []

    def ensure_node(self, path: Path) -> dict[str, Any]:
        key = canonical(path)
        if key not in self.nodes:
            self.nodes[key] = {
                "path": key,
                "status": file_status(path),
                "references": [],
                "error": None,
            }
        return self.nodes[key]

    def crawl(self, path: Path, stack: list[str], depth: int) -> None:
        key = canonical(path)
        node = self.ensure_node(path)

        if key in stack:
            cycle = stack[stack.index(key) :] + [key]
            self.cycles.append({"cycle": cycle})
            return

        if node.get("crawled"):
            return

        if node["status"] != "readable":
            node["crawled"] = True
            return

        should_scan, skip_reason = reference_scan_mode(path)
        if not should_scan:
            node["references_skipped"] = skip_reason
            node["crawled"] = True
            return

        try:
            text = path.read_text(encoding="utf-8", errors="replace")
        except OSError as exc:
            node["status"] = "unreadable"
            node["error"] = str(exc)
            node["crawled"] = True
            return

        node["crawled"] = True
        next_stack = stack + [key]

        for ref in extract_references(text):
            resolved_ref = dict(ref)
            target = ref["target"]

            if is_external(target):
                resolved_ref["status"] = "external"
                resolved_ref["source"] = key
                self.external_refs.append(resolved_ref)
                node["references"].append(resolved_ref)
                continue

            try:
                target_path = resolve_local(target, path)
            except (OSError, RuntimeError, ValueError) as exc:
                resolved_ref.update(
                    {
                        "source": key,
                        "resolved_path": target,
                        "status": "invalid",
                        "error": str(exc),
                    }
                )
                node["references"].append(resolved_ref)
                continue
            target_key = canonical(target_path)
            target_status = file_status(target_path)
            resolved_ref.update(
                {
                    "source": key,
                    "resolved_path": target_key,
                    "status": target_status,
                }
            )
            node["references"].append(resolved_ref)
            self.incoming.setdefault(target_key, []).append(
                {
                    "source": key,
                    "line": ref["line"],
                    "kind": ref["kind"],
                    "raw": ref["raw"],
                }
            )

            if target_key in next_stack:
                resolved_ref["status"] = "circular"
                cycle = next_stack[next_stack.index(target_key) :] + [target_key]
                self.cycles.append({"cycle": cycle, "source": key, "line": ref["line"]})
                continue

            if depth >= self.max_depth:
                resolved_ref["status"] = "max_depth"
                self.skipped.append(resolved_ref)
                continue

            self.crawl(target_path, next_stack, depth + 1)
            if resolved_ref["status"] == "readable":
                resolved_ref["status"] = self.nodes.get(target_key, {}).get("status", target_status)


def standard_files(project_root: Path) -> list[dict[str, Any]]:
    home_agents = Path.home() / ".codex" / "AGENTS.md"
    return [
        {
            "role": "user",
            "label": "user AGENTS.md",
            "precedence": 0,
            "path": canonical(home_agents),
        },
        {
            "role": "project",
            "label": "project AGENTS.md",
            "precedence": 1,
            "path": canonical(project_root / "AGENTS.md"),
        },
        {
            "role": "project_override",
            "label": "project AGENTS.override.md",
            "precedence": 2,
            "path": canonical(project_root / "AGENTS.override.md"),
        },
    ]


def summarize_duplicates(
    standards: list[dict[str, Any]], incoming: dict[str, list[dict[str, Any]]]
) -> list[dict[str, Any]]:
    by_path: dict[str, dict[str, Any]] = {}
    for entry in standards:
        by_path.setdefault(entry["path"], {"path": entry["path"], "standard_roles": [], "references": []})
        by_path[entry["path"]]["standard_roles"].append(entry["role"])

    for path, refs in incoming.items():
        by_path.setdefault(path, {"path": path, "standard_roles": [], "references": []})
        by_path[path]["references"].extend(refs)

    duplicates: list[dict[str, Any]] = []
    for item in by_path.values():
        count = len(item["standard_roles"]) + len(item["references"])
        if count > 1:
            duplicates.append(item)
    return sorted(duplicates, key=lambda item: item["path"])


def collect_refs_by_status(nodes: dict[str, dict[str, Any]], statuses: set[str]) -> list[dict[str, Any]]:
    matches: list[dict[str, Any]] = []
    for node in nodes.values():
        for ref in node.get("references", []):
            if ref.get("status") in statuses:
                matches.append(ref)
    return sorted(matches, key=lambda ref: (ref.get("source", ""), ref.get("line", 0), ref.get("raw", "")))


def build_report(start: Path, max_depth: int) -> dict[str, Any]:
    project_root = detect_project_root(start)
    standards = standard_files(project_root)
    auditor = Auditor(max_depth=max_depth)

    for entry in standards:
        path = Path(entry["path"])
        entry["status"] = file_status(path)
        if entry["status"] == "readable":
            auditor.crawl(path, [], 0)

    nodes = dict(sorted(auditor.nodes.items()))
    return {
        "project_root": canonical(project_root),
        "precedence_low_to_high": standards,
        "loaded_files": [
            path
            for path, node in nodes.items()
            if node.get("status") == "readable" and node.get("references_skipped") != "binary_file"
        ],
        "nodes": nodes,
        "missing_references": collect_refs_by_status(nodes, {"missing"}),
        "unreadable_references": collect_refs_by_status(nodes, {"unreadable", "not_file", "invalid"}),
        "circular_references": auditor.cycles,
        "duplicate_references": summarize_duplicates(standards, auditor.incoming),
        "external_references": sorted(
            auditor.external_refs,
            key=lambda ref: (ref.get("source", ""), ref.get("line", 0), ref.get("target", "")),
        ),
        "skipped_references": auditor.skipped,
    }


def short_status(entry: dict[str, Any]) -> str:
    if entry["status"] == "readable":
        return "present, readable"
    if entry["status"] == "missing":
        return "absent"
    return entry["status"].replace("_", " ")


def format_ref(ref: dict[str, Any]) -> str:
    source = ref.get("source", "<unknown>")
    line = ref.get("line", "?")
    raw = ref.get("raw", ref.get("target", ""))
    resolved = ref.get("resolved_path") or ref.get("target") or ""
    return f"{source}:{line} {raw} -> {resolved}"


def append_ref_section(lines: list[str], title: str, refs: list[dict[str, Any]], limit: int = 20) -> None:
    lines.append("")
    lines.append(f"{title}: {len(refs)}")
    for ref in refs[:limit]:
        lines.append(f"  - {format_ref(ref)}")
    if len(refs) > limit:
        lines.append(f"  - ... {len(refs) - limit} more; rerun with --json for the complete list")


def format_report(report: dict[str, Any]) -> str:
    lines: list[str] = []
    lines.append("AGENTS reference audit")
    lines.append(f"Project root: {report['project_root']}")
    lines.append("")
    lines.append("Precedence (low -> high):")
    for entry in sorted(report["precedence_low_to_high"], key=lambda item: item["precedence"]):
        lines.append(f"  {entry['precedence'] + 1}. {entry['label']}: {entry['path']} ({short_status(entry)})")

    lines.append("")
    lines.append(f"Loaded local files: {len(report['loaded_files'])}")
    for path in report["loaded_files"]:
        lines.append(f"  - {path}")

    sections = [
        ("Missing local references", report["missing_references"]),
        ("Unreadable or non-file references", report["unreadable_references"]),
        ("External URLs (reported, not fetched)", report["external_references"]),
        ("Max-depth skipped references", report["skipped_references"]),
    ]
    for title, refs in sections:
        append_ref_section(lines, title, refs)

    lines.append("")
    lines.append(f"Circular references: {len(report['circular_references'])}")
    for cycle in report["circular_references"]:
        lines.append("  - " + " -> ".join(cycle["cycle"]))

    lines.append("")
    lines.append(f"Duplicate paths/references: {len(report['duplicate_references'])}")
    for item in report["duplicate_references"]:
        roles = ", ".join(item["standard_roles"]) or "none"
        lines.append(f"  - {item['path']} (standard roles: {roles}; refs: {len(item['references'])})")

    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("path", nargs="?", default=os.getcwd(), help="Project directory or AGENTS file to audit")
    parser.add_argument("--json", action="store_true", help="Emit machine-readable JSON")
    parser.add_argument("--max-depth", type=int, default=6, help="Maximum recursive reference depth")
    parser.add_argument("--strict", action="store_true", help="Exit nonzero when reference issues are found")
    args = parser.parse_args()

    report = build_report(Path(args.path), max_depth=args.max_depth)
    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(format_report(report))

    has_issues = any(
        report[key]
        for key in (
            "missing_references",
            "unreadable_references",
            "circular_references",
            "skipped_references",
        )
    )
    return 1 if args.strict and has_issues else 0


if __name__ == "__main__":
    sys.exit(main())
