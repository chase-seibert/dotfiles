#!/usr/bin/env bash
set -euo pipefail

# Latest upstream stable release, verified 2026-09-04. Keep the tag and digest
# together when updating. No Homebrew, compiler, or system Python changes needed.
version=22.5.3
sha256=00daf3698e17ac3ac788d529877c03ee80c3790472a85d0ed063ac3a354c37b1

for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$brew_path" ]; then
    eval "$("$brew_path" shellenv)"
    break
  fi
done

if command -v brew >/dev/null 2>&1; then
  brew update
  if brew list --versions autojump >/dev/null 2>&1; then
    brew upgrade autojump
  else
    brew install autojump
  fi
  exit 0
fi

command -v python3 >/dev/null 2>&1 || {
  echo 'Autojump requires Python 3. Install Python 3, then rerun this script.' >&2
  exit 1
}

autojump_tmp=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-autojump.XXXXXXXX")
trap 'rm -rf "$autojump_tmp"' EXIT
curl -fL --retry 3 "https://github.com/wting/autojump/archive/refs/tags/release-v${version}.tar.gz" -o "$autojump_tmp/source.tar.gz"
python3 - "$autojump_tmp/source.tar.gz" "$sha256" <<'PY'
import hashlib
import sys
from pathlib import Path
if hashlib.sha256(Path(sys.argv[1]).read_bytes()).hexdigest() != sys.argv[2]:
    raise SystemExit('Autojump archive checksum mismatch')
PY
tar -xzf "$autojump_tmp/source.tar.gz" -C "$autojump_tmp"
cd "$autojump_tmp/autojump-release-v${version}"

# Upstream uses /usr/bin/env python, which is absent on current macOS.
python3 - <<'PY'
from pathlib import Path
path = Path('bin/autojump')
content = path.read_text()
path.write_text(content.replace('#!/usr/bin/env python\n', '#!/usr/bin/env python3\n', 1))
PY

python3 install.py
"$HOME/.autojump/bin/autojump" --version
