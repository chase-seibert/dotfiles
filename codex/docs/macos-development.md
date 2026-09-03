Use this for native macOS apps, SwiftUI on macOS, AppKit interop, signing,
notarization, packaging, menu bar apps, and desktop-only Swift tooling.

## General 
- Prefer native macOS conventions
- Prefer SwiftUI
- Apps should look mac-native; follow Apple's Human Interface Guidelines 
- For "Mac-assed Mac apps" guidance, also load `/Users/cseibert/.codex/docs/mac-assed-mac-apps.md`
- Apps should provide user-facing app font scaling with Command +/- and a reset shortcut such as Command 0. Persist the setting and expose it in Settings when the app has preferences UI.
- When making a code change, rebuild and relaunch the app

## Data Storage Defaults

- Prefer Apple's SwiftData framework with its default SQLite-backed store from
  the start for growing, structured, editable app-owned data: logs, history, saved
  items, favorites, relationships, and queryable collections. Transactions,
  incremental writes, and concurrent access are reasons to use it before the
  dataset becomes large.
- Do not put all state in a database. Use UserDefaults for small, bounded
  preferences; Keychain for secrets; and files for media, documents, imports,
  exports, and bundled resources. Keep document-based apps document-based, with
  native open/save, autosave, and versioning behavior; SQLite can support their
  internals without replacing user-owned documents with a hidden global store.
- Reserve whole-file JSON storage for prototypes or genuinely small, bounded,
  single-writer datasets. JSON remains useful for static resources, interchange,
  and per-record database payloads; avoid a growing whole-library JSON blob.
- Keep persistence behind a small repository interface, independent of views.
  Use SwiftData APIs rather than raw SQLite or handwritten SQL, and avoid
  unnecessary dependencies. Do not replace a suitable existing persistence stack
  solely to follow this default.
- Keep immutable catalogs and disposable caches separate from authoritative
  user data, and bound diagnostic and analytics retention.

### Reliability And Migration

- Store durable app-owned state in Application Support within the appropriate
  container. Use an entitled App Group when sharing with helpers or extensions;
  fail visibly if required shared storage is unavailable. Keep user documents
  in their chosen locations and never use caches as their only durable copy.
- Keep database work off the main thread, use indexed bounded reads, and commit
  targeted transactional updates. Coordinate multiple windows, helpers, and
  extensions; a process-local queue alone cannot coordinate other processes.
  Never overwrite the store with a stale view's whole-data snapshot.
- Version schemas and test migrations. Preserve originals and a verified backup,
  then validate records, IDs, relationships, ordering, and counts before switching
  stores. A verified one-off conversion can be enough for an unreleased,
  single-user app; do not skip preservation and recovery planning.
- Surface corrupt, unreadable, and unsupported-store errors. Never silently
  replace valuable data with an empty store or delete a database to fix a load
  error. Provide a practical export/restore path and test it along with relaunch
  and representative multi-year data.
- Use SQLite's backup API or the framework's consistent export mechanism for a
  live database. Copying just the main file can lose committed WAL contents;
  do not mix files and sidecars from different snapshots.

### Backup Is Not Cloud Sync

- Treat Time Machine backups, Migration Assistant transfers, and ongoing iCloud
  synchronization as separate requirements. A local SQLite database does not
  automatically sync between Macs, and iCloud Drive is not a whole-Mac backup.
- Implement cloud sync deliberately when required. Do not put a live SQLite
  database in an iCloud Drive or other file-sync folder and assume concurrent
  edits, conflicts, and WAL files will be handled safely.
- Keep irreplaceable data eligible for the chosen backup method and verify an
  actual restore. Do not promise recovery merely because files are in a normal
  support directory. Keep a separate verified export before retiring a Mac and
  confirm the restored data and settings on its replacement.

For icons, see `/Users/cseibert/.codex/docs/ios-development.md`.
