---
name: name-game-whos-who
description: Create and maintain a self-contained, mobile-friendly, CSS-only HTML headshot quiz from group photos, individual photos, and a user-supplied list of names. Use when Codex needs to build or revise a Name Game / Who's Who experience with full-bleed Brave family cards, overlaid Princess photo tiles, per-person crop adjustments, a sticky top menu bar, hamburger navigation, offline embedded images, and explicit name-to-face mappings.
---

# Name Game: Who's Who

Build one offline HTML quiz that helps the user learn which supplied name belongs to each supplied portrait. Keep the interaction HTML/CSS-only: do not use JavaScript.

## Inputs

Accept any combination of:

- Group photos containing several people.
- Individual photos that provide better portraits.
- A list of names.
- Optional nicknames, titles, or secondary labels.
- An optional output filename/title.
- An optional maximum HTML size; default to 3 MB.

Let the user provide these incrementally across the conversation. Do not require every input before beginning useful work.

## Build workflow

For each group photo:

1. Find each clearly visible human face.
2. Make a separate portrait-oriented crop with enough head and upper-body context to remain recognizable.
3. Omit faces too obscured to make a useful crop unless the user asks to keep them.
4. Resize and compress sensibly for a phone-sized card.
5. Do not identify anyone from appearance.

When identities are not already explicitly established, show exactly one portrait at a time and ask the user who it is. Treat a name-to-face assignment as authoritative only when the user explicitly supplies or confirms it. Accept minor spelling variations when the intended supplied person is unambiguous; ask for clarification when multiple supplied people could match.

When the user supplies a named individual photo, replace that person's existing image rather than adding a duplicate. Preserve the person's name, nickname/title, order, navigation, and other established mappings. When adding or removing people, repair the anchor chain and keep the final card returning to the top.

Keep names and nicknames/titles as readable literal HTML text so they remain easy to find and edit.

## Card layout

Create a vertically scrolling, mobile-first quiz. Treat each family card as one Brave and one or more Princesses.

- Make cards roughly 80–85% of a small mobile viewport's height, leaving a hint of the next card below.
- Use the available width with a small margin and `svh` where useful.
- Use `object-fit: cover` for portrait presentation.
- Make the Brave photo a full-card background layer.
- Keep the Brave title/name over the Brave photo, positioned above the Princess row.
- Overlay the Princess photo tiles across the bottom of the Brave photo instead of placing them in a separate solid-color band.
- Make multiple Princess tiles remain in one horizontal row when they fit.
- Left-align a single Princess tile; do not center it merely because it is the only tile.
- Make each Princess tile fill its photo box and place the title/name at the bottom of that same tile.
- Reveal Princess identity text directly over the photo without a gradient panel; use text shadow or another subtle contrast aid if needed.
- Keep Brave and Princess identity containers in normal-flow flex columns so wrapped names cannot collide with titles or hints.

Prefer readable semantic classes such as `.family-card`, `.family-visual`, `.brave-pane`, `.princesses`, `.princess`, `.princess-photo`, `.brave-identity`, and `.princess-identity`. Use a small CSS focal-point rule or an inline style for a specific person when a face needs `object-position` or a requested zoom; do not change unrelated crops.

## CSS-only interaction

Hide each identity initially using an HTML checkbox or equivalent CSS-only state. Preserve this sequence:

`hidden -> first tap -> identity revealed -> second tap -> next family`

On the first tap, reveal the Brave and Princess names, titles, and a subtle indication that another tap advances. After reveal, enable a full-card anchor to the next family. The final family's second tap must return to the top. Implement this with a checkbox state and a positioned anchor whose active state is enabled after `:checked`.

## Navigation chrome

Keep the top menu bar visible while scrolling:

- Use a sticky intro/header bar at the top with the quiz title and short instructions.
- Reserve space for a fixed hamburger button, including safe-area insets on phones.
- Open a CSS-only slide-out Braves navigation panel through a fragment target such as `#braves-menu`.
- Include a close control, backdrop, and one anchor link per family/Brave.
- Keep the menu panel scrollable when the list is taller than the viewport.
- Preserve smooth anchor scrolling and use scroll snapping only when it does not interfere with normal scrolling.

Use readable controls and visible focus styles. Keep the hamburger button and menu panel above the cards with explicit stacking order.

## Images and file constraints

Return one `.html` file containing all HTML, CSS, and portrait image data. It must work after download with no network connection.

- Embed every image as a data URI, normally a base64 JPEG for photographic content.
- Resize typical portraits to about 600–800 px wide and use moderate JPEG compression.
- Prefer quality that looks good on a phone while keeping the complete HTML comfortably below the requested limit.
- Use `object-position` for face focal points and `transform: scale(...)` only for a requested per-person zoom; check that the face remains visible inside the tile.
- Do not use JavaScript, external stylesheets, external fonts, CDNs, external image URLs, or runtime-required sidecar files.
- Keep the artifact self-contained, JavaScript-free, and under 15 MB unless the user specifies a stricter limit.

Use literal, readable identity markup, for example:

```html
<span class="name">Joao Almeida</span>
<span class="nickname">Cherry Island</span>
```

For unmapped portraits, use obvious placeholders such as `Name 01`, `Name 02`, and `Name 03`, then replace them after the user completes mapping.

## Validation before delivery

Verify:

- Every intended person has exactly one card and the correct mapped image.
- Every mapped name and nickname/title matches the user's explicit input.
- No identity was inferred from appearance.
- The Brave remains the background and Princess tiles overlay the lower portion as intended.
- Multiple Princesses stay in a row and a single Princess is left-aligned.
- Princess identity text appears at the bottom of each tile without a reveal gradient.
- The sticky top bar remains visible while scrolling and the hamburger menu opens, closes, and links to every family.
- The first tap reveals identity and the second tap advances.
- The final card returns to the top.
- Wrapped names do not overlap titles or navigation hints.
- No JavaScript or external runtime resource exists.
- Every portrait is embedded.
- The complete file is below the requested size limit.
- The requested filename is used.

Return the finished HTML as a downloadable file.
