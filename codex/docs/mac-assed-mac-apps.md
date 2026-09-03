# Mac-Assed Mac Apps

Use this when building or reviewing macOS apps where feeling like a real Mac
app matters. The ATP 698 transcript frames the problem well: "you know it when
you see it" is not enough. Treat Mac feel as an explicit product requirement
with observable behavior.

## North Star

- A Mac app should feel at home on macOS, not merely be an app that happens to
  run on macOS.
- Prefer the platform's idioms over cross-platform sameness. If a web, iOS, or
  generic desktop pattern conflicts with Mac behavior, the Mac behavior wins.
- Native feel is not a final coat of polish. It shapes data model, windowing,
  command routing, menus, keyboard behavior, document handling, and system
  integration from the start.
- The app should reward experienced Mac users without punishing new users.
  Common actions should be discoverable in the UI and also available through
  menus, keyboard shortcuts, context menus, and automation surfaces when useful.

## Native Building Blocks

- Prefer SwiftUI for macOS app structure when it can express the correct
  behavior cleanly.
- Use AppKit interop when SwiftUI cannot provide the expected desktop behavior.
  Do not accept iOS-shaped behavior just because it is easier in SwiftUI.
- Use real macOS primitives instead of custom imitations: menu bar commands,
  toolbar items, context menus, sheets, popovers, panels, `Settings`,
  `NSOpenPanel`, `NSSavePanel`, `NSUndoManager`, `NSPasteboard`, and
  `NSDocument` for document-based apps.
- Avoid reimplementing standard controls such as file pickers, menus, text
  fields, lists, tables, sidebars, tab views, and toolbars unless there is a
  concrete product reason.
- Avoid Electron, Catalyst, or a web view shell when the goal is a truly native
  Mac app, unless the user explicitly prioritizes cross-platform reach over Mac
  fidelity.

## Windows

- Design around real desktop windowing. Users should be able to resize windows,
  use multiple windows when the app model supports it, minimize, zoom, full
  screen, close, reopen, and restore state predictably.
- Set sensible minimum window sizes. Do not build fixed phone-width layouts or
  content that only works at one size.
- Use standard title bar, toolbar, sidebar, split view, tab, inspector, sheet,
  and panel patterns where they fit.
- Do not let custom chrome collide with traffic lights, title bars, toolbars,
  drag regions, full screen behavior, or window restoration.
- Multi-document and multi-window apps should behave correctly with several
  windows open across Spaces, displays, and full screen contexts.

## Menus And Commands

- Build a complete menu bar. Important app actions should not exist only as
  buttons inside one view.
- Provide standard commands where applicable: New, Open, Open Recent, Close,
  Save, Save As, Duplicate, Revert, Export, Print, Undo, Redo, Cut, Copy, Paste,
  Delete, Select All, Find, Zoom, Minimize, Bring All to Front, Help, Settings,
  Hide, and Quit.
- Use expected shortcuts, including Command-comma, for Settings, Command-Q for Quit,
  Command-W for Close, Command-N for New, Command-O for Open, Command-S for
  Save, Command-F for Find, Command-Z and Shift-Command-Z for Undo and Redo.
- Validate commands by selection and focus state. Disabled commands should tell
  the truth about what can happen now.
- Add context menus for objects users naturally right-click, especially rows,
  files, text, items, canvas selections, and sidebar entries.

## Keyboard First

- A frequent user should be able to operate the app efficiently without leaving
  the keyboard.
- Support Tab navigation, focus rings, default buttons, cancel buttons, Escape
  to dismiss transient UI, Return to confirm where appropriate, and full
  keyboard access.
- Keep shortcuts consistent with system and app-category conventions. Do not
  invent cute shortcuts when the Mac already has a norm.
- Implement semantic undo and redo for user edits. Undo should describe actions
  in the Edit menu when possible.
- Make search and find fast. Command-F should focus the right search field or
  open the expected find UI.

## Files And Data

- Document apps should use the document architecture unless there is a strong
  reason not to. Support Open, Save, Save As, Duplicate, Revert, autosave,
  versions, recent documents, file icons, and Finder integration.
- Non-document apps should still respect Mac data flows: drag and drop,
  copy/paste, open with, import/export, Quick Look, Share, Services, and
  predictable local file access where relevant.
- Use system pasteboard types and drag representations so the app cooperates
  with Finder and other Mac apps.
- Preserve user work aggressively. Crashes, quits, restarts, and window closes
  should not feel dangerous.
- Avoid cloud-only assumptions when local-first behavior is natural for the app.

## System Integration

- Respect system appearance, accent color, text size, scroll bar preferences,
  reduce motion, reduce transparency, high contrast, VoiceOver, keyboard access,
  and localization.
- Use Dock badges, notifications, menu bar status items, widgets, Spotlight,
  Quick Look, Shortcuts, App Intents, Services, Share extensions, and login
  items only when they serve the product.
- Provide a useful Help menu for non-trivial apps.
- Use the system Settings scene or a Mac-standard preferences window for
  preferences. Persist settings and make them reversible.
- Support app font scaling with Command-+, Command--, and Command-0 when the app
  contains user-facing reading or editing surfaces.

## Visual And Interaction Feel

- Use system fonts, colors, controls, spacing, materials, and SF Symbols by
  default. Custom styling should be intentional and still feel comfortable on
  macOS.
- Desktop density is allowed. Do not inflate touch targets, typography, or
  navigation patterns just because they came from iOS.
- Prefer toolbars, sidebars, inspectors, split views, popovers, and panels over
  hamburger menus, bottom tab bars, giant cards, full-screen modal flows, and
  mobile navigation stacks.
- Use vibrancy, translucent material, and custom chrome sparingly. If the effect
  makes text less readable or the window less predictable, remove it.
- Text editing should feel like Mac text editing: selection, insertion point,
  standard shortcuts, spellcheck, substitutions, Services, and context menus
  should work naturally.

## Performance And Respect

- Launch quickly and keep the main thread responsive. A Mac app should not make
  the machine feel heavier than the work deserves.
- Avoid unnecessary background work, polling, memory growth, network calls, and
  energy use. Background activity should be visible or controllable when users
  would care.
- App state should survive relaunch. Window placement, open documents, sidebar
  selections, filters, and recent choices should come back when appropriate.
- Errors should be recoverable and written in Mac-native language. Prefer
  specific actions over generic failure dialogs.
- Updates, permissions, notifications, and login item behavior should be
  explicit and respectful.

## Red Flags

- The app is one fixed-size window.
- The menu bar is empty, generic, or disconnected from app actions.
- Common commands only exist as on-screen buttons.
- There is no keyboard path for frequent actions.
- The app uses custom file pickers, custom text fields, custom menus, or fake
  sheets where system controls would work.
- The layout looks like an iPad app stretched onto a monitor.
- The app ignores drag and drop, copy/paste, undo/redo, recent documents, or
  window restoration.
- The app hides everything behind a web-style sidebar, hamburger menu, or
  account-first flow before local work can happen.
- The app technically runs on macOS but behaves as if macOS is just another
  browser tab.

## Codex Checklist

- Before editing, inspect the app type, target macOS version, entitlements,
  existing SwiftUI/AppKit patterns, menu commands, window structure, and project
  instructions.
- Prefer established local architecture. Add AppKit bridges narrowly when they
  restore standard Mac behavior.
- After UI changes, rebuild and relaunch the app when possible.
- Manually check resizing, dark and light appearance, keyboard shortcuts, menu
  validation, context menus, focus, undo/redo, persistence, and basic
  accessibility.
- If a requested design would make the app less Mac-native, call that out and
  offer the Mac-native alternative.
