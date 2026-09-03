---
name: free-macos-disk-space
description: Diagnose macOS disk usage and reclaim space conservatively. Use when a user asks why a Mac is full, what System Data or Documents contains, which files are safe to remove, or asks Codex to free disk space in measured chunks.
---

# Free macOS Disk Space

Find high-value, low-risk space savings without treating macOS storage categories as authoritative or deleting user data by accident.

## Authorization boundary

- A request to diagnose or suggest ideas authorizes read-only inspection only.
- Before deleting, moving to Trash, uninstalling, emptying Trash, or running a cleanup command, obtain authorization for the exact category or targets unless the user already requested that exact action.
- Treat permanent deletion and emptying Trash as destructive. Say whether recovery is possible.
- Work in conservative chunks when requested. Measure and report one chunk, then stop for direction.

## Audit before cleanup

Record actual free space from the writable Data volume before estimating savings:

```bash
df -k /System/Volumes/Data
```

Treat System Settings categories as hints, not directories. In particular:

- **Documents** can include hidden home folders such as `~/.codex`, `~/projects`, `.android`, archives, and generated build output.
- **System Data** can include user and system Library data, caches, developer runtimes, simulator state, swap, update snapshots, and app support files.
- Category totals may lag after cleanup or double-count shared/APFS-cloned data.

Start with targeted measurements instead of scanning the whole disk:

```bash
du -xsk "$HOME/.codex" "$HOME/projects" "$HOME/.android" 2>/dev/null
du -xsk "$HOME/Library/Application Support" "$HOME/Library/Caches" \
  "$HOME/Library/Developer" "$HOME/Library/Containers" 2>/dev/null
du -xsk /System/Volumes/Data/Library/Developer \
  /System/Volumes/Data/private/var/vm \
  /System/Volumes/Data/private/var/folders 2>/dev/null
```

Break large results down one level at a time. Prefer null-delimited `find -print0` and `xargs -0` when names may contain spaces. Do not rely on an unmatched zsh glob; it can abort an otherwise useful command.

## Rank cleanup candidates

Prefer regenerable data over personal or application state.

### Codex temporary marketplace staging

An abnormally large `~/.codex/.tmp/bundled-marketplaces` may contain abandoned `openai-bundled.staging-*` directories.

Before proposing removal:

1. Resolve the exact cache root and confirm every target is a real directory directly below it.
2. Count targets, check their modification times, check for symlinks, and check whether any running process has an open file in them.
3. Prefer quitting Codex. If the active conversation prevents that, delete only clearly stale staging directories with no open handles.
4. Preserve `openai-bundled` without the `.staging-*` suffix, plus all sessions, archived sessions, worktrees, plugins, databases, logs, attachments, and generated artifacts outside this exact temporary subtree.
5. Request approval immediately before deletion and use an exact, depth-limited target pattern.

Do not generalize one observed cache accumulation into permission to clear all of `~/.codex/.tmp` or `~/.codex`.

### Project build products

Search for conventional generated directories such as `build`, `.build`, `DerivedData`, `node_modules`, `dist`, `target`, `.gradle`, disposable `.venv` or `venv`, and `Pods`:

```bash
find "$HOME/projects" -mindepth 2 -maxdepth 5 -type d \
  \( -name node_modules -o -name DerivedData -o -name build \
  -o -name .build -o -name dist -o -name target -o -name .gradle \
  -o -name .venv -o -name venv -o -name Pods \) -prune -print0
```

Names alone do not prove safety. Check the project type and version-control state, distinguish source-controlled assets from generated output, preview sizes and exact paths, and obtain approval. Prefer project-native clean commands when they are reliable and bounded.

### Apple developer data

Inspect these separately because totals may overlap through APFS clones:

- `~/Library/Developer/CoreSimulator/Devices`
- `~/Library/Developer/Xcode/iOS DeviceSupport`
- `~/Library/Developer/Xcode/DerivedData`
- `/Library/Developer/CoreSimulator`

Prefer Xcode's UI for cleanup:

- Delete unused simulator devices in **Window > Devices and Simulators**.
- Remove unused simulator runtimes in **Xcode > Settings > Components**.
- Keep Device Support for the current physical-device OS; older versions are usually regenerable if the device is connected again.

Never remove all simulator or Device Support data merely because it is large.

### Android, browsers, and app support

- Remove unused Android virtual devices through Android Studio's Device Manager rather than deleting `.android/avd` wholesale.
- Clear browser cached images/files through the browser. Do not delete a complete Chrome or Arc profile merely to remove cache.
- Treat VM bundles, application-support directories, Capture thumbnails, and similar data as app-specific. Explain whether removal causes a redownload, loses local state, or is merely regenerable.
- Uninstall unused applications through their supported uninstall path when associated data matters.

## Execute cleanup safely

- Resolve and validate every destructive target with read-only checks first.
- Avoid broad roots, unresolved variables, recursive wildcards, and commands that could expand outside the intended directory.
- Prefer moving to Trash when the user wants recoverability and has enough headroom. Explain that Trash does not release space until emptied.
- If the user explicitly needs immediate reclaimed space and approves permanent deletion, delete only the validated targets.
- For a high-file-count deletion, silence is normal. Monitor remaining target count and `df` rather than interrupting or starting a second deletion.
- Verify preserved neighboring data after cleanup.

## Measurement and reporting

Use the `Available` blocks from `df -k /System/Volumes/Data` before and after. Report the measured delta in both GiB and decimal GB when useful; do not substitute the earlier `du` estimate. Also report:

- free space before and after;
- volume utilization before and after;
- exact category or target pattern removed;
- what important neighboring data was preserved;
- whether deletion is recoverable; and
- which approved categories remain untouched.

## Operational pitfalls

- Broad `du` scans can exceed a tool timeout and return no visible result. Split them into independent targeted paths; if a command yields a session ID, poll that session rather than restarting the scan.
- `du` can exit nonzero because privacy-protected children were unreadable while still returning useful partial totals. Label those totals approximate.
- Spotlight queries may return nothing because of indexing or privacy, so do not treat an empty `mdfind` result as proof that no large files exist.
- `du` can overstate the space that deletion will reclaim when APFS clones or shared blocks are involved. Trust the post-cleanup `df` delta.
- macOS Storage categories can remain stale after files are removed. Actual free blocks are the immediate source of truth.
- Deleting hundreds of thousands of small files may take much longer than deleting the same byte count in a few large files. Provide progress updates during the operation.
