Use this for iOS apps, SwiftUI on iPhone/iPad, app intents, simulator debugging,
performance, memory, widgets, and system integrations.

- Prefer SwiftUI and current Apple platform patterns unless the project is
  explicitly UIKit-first
- Prefer simulator build/run/test workflows for local verification

## Data Storage Defaults

- Prefer Apple's SwiftData framework with its default SQLite-backed store from
  the start for growing, structured, editable user data: logs, history, saved
  items, favorites, relationships, and queryable collections.
  Do not wait for years of history or performance problems to justify a database;
  transactions and safe incremental writes matter even for small datasets.
- Database storage is not required for every piece of state. Use
  UserDefaults for small, bounded preferences and toggles; Keychain for secrets;
  and files for photos, documents, imports, exports, and bundled resources.
- JSON is appropriate for prototypes, static resources, interchange, or genuinely
  small, bounded datasets with one writer. Avoid rewriting an entire growing
  diary or library as one JSON file. JSON payloads inside individual database
  rows are fine when useful fields remain queryable.
- Put persistence behind a small repository interface, independent of SwiftUI.
  Use SwiftData APIs rather than raw SQLite or handwritten SQL, and avoid
  unnecessary dependencies. Do not replace a suitable existing persistence stack
  solely to follow this default.
- Keep immutable catalogs and disposable caches separate from authoritative
  user data. Give diagnostics and analytics explicit retention limits rather
  than treating them as unbounded diary history.

### Reliability And Migration

- Store durable app-owned data in Application Support, or an entitled App Group
  when the app and extensions need to share it. Never use caches or temporary
  storage for the only copy of user-created data.
- Use indexed, bounded queries and targeted transactional updates off the main
  thread. Coordinate app, widget, and intent writers through the database; a
  process-local queue does not prevent cross-process lost updates. Never save
  a stale UI snapshot over the whole store.
- Version the schema and test migrations. Preserve originals, make a verified
  backup, and validate records, IDs, relationships, ordering, and counts before
  switching stores. A verified one-off conversion is reasonable for an
  unreleased, single-user app; data preservation is still required.
- Fail visibly on corrupt, unreadable, or unsupported storage, or unavailable
  required App Group access. Never recover by silently creating an empty writable
  diary, deleting the existing database, or falling back to stale data.
- Use SQLite's backup API or the persistence framework's consistent export
  mechanism for live backups. Copying only the main SQLite file can omit changes
  in its WAL. Test relaunch, export/restore, and representative multi-year data.

### Backup Is Not Cloud Sync

- SQLite and JSON are local storage formats, not iCloud synchronization features.
  Treat iPhone backup/restore, device transfer, and ongoing cross-device sync as
  separate requirements. Implement cloud sync deliberately when needed; do not
  place a live SQLite database in a file-sync folder as a substitute.
- Keep irreplaceable user data eligible for backup. Do not promise an iCloud
  restore merely because the path appears eligible: verify the app's backup
  setting, a completed recent backup, and an actual restore. A restore only
  recovers the state captured by that backup, not necessarily the latest edit.
- Privately deployed development apps may require redeployment on a new phone.
  Before retiring the old device, keep a separate verified export and confirm
  history and settings on the replacement. An on-device migration backup alone
  does not protect against uninstalling the app or losing the phone.

## New SwiftUI Projects

For new iOS SwiftUI projects, include a project `Makefile` with simulator
build/run targets and physical-device build/deploy targets. The Makefile should
include at least `sim-build`, `sim-launch`, `phone-build`, `phone-install`,
`phone-launch`, and `phone-deploy`.

Default the physical device to Chase's iPhone 17 Pro, and use Chase's configured
Apple Personal Team for signing:

```make
DEVICE_ID ?= 00008150-000E41422E40401C
DEVELOPMENT_TEAM ?= 96NAC4VTEN
```

Use the configured Apple Personal Team. DO NOT use the default deploy team for
new iOS app projects unless Chase explicitly asks for it.

Use this Makefile shape for SwiftUI app projects, adjusted for the project,
scheme, app name, and bundle id:

```make
PROJECT := MyApp.xcodeproj
SCHEME := MyApp
CONFIGURATION := Debug
DERIVED_DATA := build
APP_NAME := MyApp
BUNDLE_ID := com.cseibert.MyApp

SIM_DEVICE_NAME ?= iPhone 17 Pro
SIM_DESTINATION ?= platform=iOS Simulator,name=$(SIM_DEVICE_NAME)
GENERIC_SIM_DESTINATION := generic/platform=iOS Simulator

DEVICE_ID ?= 00008150-000E41422E40401C
DEVELOPMENT_TEAM ?= 96NAC4VTEN

.PHONY: sim-build sim-launch phone-build phone-install phone-launch phone-deploy

sim-build:
	xcodebuild \
	  -project $(PROJECT) \
	  -scheme $(SCHEME) \
	  -configuration $(CONFIGURATION) \
	  -destination '$(GENERIC_SIM_DESTINATION)' \
	  -derivedDataPath $(DERIVED_DATA) \
	  CODE_SIGNING_ALLOWED=NO \
	  build

sim-launch: sim-build
	@set -eu; \
	UDID=$$(xcrun simctl list devices available | awk -F '[()]' -v name="$(SIM_DEVICE_NAME)" '{ display=$$1; sub(/^[[:space:]]+/, "", display); sub(/[[:space:]]+$$/, "", display); if (display == name && $$0 !~ /unavailable/) { print $$2; exit } }'); \
	if [ -z "$$UDID" ]; then \
	  echo "No available simulator named $(SIM_DEVICE_NAME)."; \
	  xcrun simctl list devices available; \
	  exit 1; \
	fi; \
	xcrun simctl boot "$$UDID" >/dev/null 2>&1 || true; \
	xcrun simctl bootstatus "$$UDID" -b; \
	open -a Simulator --args -CurrentDeviceUDID "$$UDID"; \
	xcrun simctl install "$$UDID" "$(DERIVED_DATA)/Build/Products/Debug-iphonesimulator/$(APP_NAME).app"; \
	xcrun simctl launch "$$UDID" $(BUNDLE_ID)

phone-build:
	xcodebuild \
	  -project $(PROJECT) \
	  -scheme $(SCHEME) \
	  -configuration $(CONFIGURATION) \
	  -destination 'platform=iOS,id=$(DEVICE_ID)' \
	  -derivedDataPath $(DERIVED_DATA) \
	  CODE_SIGN_STYLE=Automatic \
	  DEVELOPMENT_TEAM=$(DEVELOPMENT_TEAM) \
	  -allowProvisioningUpdates \
	  -allowProvisioningDeviceRegistration \
	  build

phone-install:
	xcrun devicectl device install app --device $(DEVICE_ID) "$(DERIVED_DATA)/Build/Products/Debug-iphoneos/$(APP_NAME).app"

phone-launch:
	xcrun devicectl device process launch --device $(DEVICE_ID) --terminate-existing $(BUNDLE_ID)

phone-deploy: phone-build phone-install phone-launch
```

Use `CODE_SIGNING_ALLOWED=NO` only for simulator compile checks. Physical-device
builds should use automatic signing with `CODE_SIGN_STYLE=Automatic`,
`DEVELOPMENT_TEAM=$(DEVELOPMENT_TEAM)`, `-allowProvisioningUpdates`, and
`-allowProvisioningDeviceRegistration`.

## Icons 
1. Keep it simple. One focal point, minimal detail.
2. Design at 1024×1024 using vectors, then scale down. Always review the icon at small sizes like 40px to 60px.
3. Do not bake in rounded corners.
4. Prioritize silhouette and contrast over decoration. The icon should still be recognizable in grayscale.
5. Avoid text and tiny typography
6. Use bold shapes and thicker lines
7. One dominant color 
