# Patterns and Pitfalls for OpenTUI

This reference distills practical patterns and common mistakes when working with OpenTUI.

## High-level patterns

### 1. Box-based app shells

Pattern: treat `<box>` as your equivalent of `div` for major regions.

Typical shell:

- Root `<box flexDirection="column">`.
- Header `<box>`.
- Main area `<box flexDirection="row" flexGrow={1}>` with sidebar and content.
- Optional footer `<box>`.

Benefits:

- Clear structure, easier to reason about.
- Works well across different terminal sizes.

### 2. Scrollable lists and logs

Pattern: use `<scrollbox>` for long, dynamic content.

Guidelines:

- Keep each row a `<box>` with `width="100%"` and small padding.
- Turn on `stickyScroll` at the bottom for logs/chat.
- Leave `viewportCulling` enabled to avoid rendering off-screen rows.

### 3. Focused forms

Pattern: explicit control of focus and navigation.

- Use one `focused` input at a time.
- Use `useKeyboard` for Tab and global shortcuts.
- Reflect focus visually via border colors or titles.

## Common pitfalls and fixes

### Pitfall: treating the terminal like a browser

- **Symptom:** designs that rely on pixel-perfect placement or rich visuals do not translate well.
- **Fix:**
  - Design for **characters**, not pixels.
  - Accept coarser layouts (e.g. half-width panels, thirds) instead of tight grids.
  - Use borders, background colors, and spacing sparingly for emphasis.

### Pitfall: ignoring small terminal sizes

- **Symptom:** layouts that look good at 120x40 but break badly at 80x24.
- **Fix:**
  - Test mentally at 80x24, or use `useTerminalDimensions` to adapt.
  - Make sidebars collapsible when width is below a threshold.

### Pitfall: overloading a single screen

- **Symptom:** too many panels or widgets, high cognitive load.
- **Fix:**
  - Split flows into multiple screens or modes.
  - Use tabs or keybindings to switch between views instead of shrinking everything.

### Pitfall: broken keyboard focus

- **Symptom:** keystrokes go to the wrong component, or nothing appears to respond.
- **Fix:**
  - Track focus in a single source of truth (e.g. `focusedField: "username" | "password" | ...`).
  - Drive `focused` props from that state only.
  - Avoid multiple components with `focused={true}`.

### Pitfall: poor performance with large lists

- **Symptom:** sluggish updates when displaying hundreds of rows.
- **Fix:**
  - Always use `<scrollbox>` and keep `viewportCulling` enabled.
  - Simplify row components; avoid unnecessary nesting and heavy computations per row.

### Pitfall: misusing React DOM habits

- **Symptom:** relying on DOM-specific concepts like CSS classes or DOM events.
- **Fix:**
  - Remember that events are **component-specific**, not browser DOM events.
  - Use the documented props (`onInput`, `onSubmit`, `onChange`, `focused`).
  - Use `style` and direct props for layout, not classes.

## Production-readiness cautions

OpenTUI is powerful but experimental.

When advising on production use:

- Recommend OpenTUI for internal tools and experiments.
- Warn about license/versioning and long-term maintenance risk.
- Suggest more mature TUI libraries for mission-critical or customer-facing systems if stability is a hard requirement.

## Checklist for reviews

When reviewing an OpenTUI design or implementation, walk through this checklist:

- [ ] Layout uses clear `<box>` hierarchies with sensible flex props.
- [ ] Scrollable areas use `<scrollbox>` with viewport culling.
- [ ] Focus and keyboard behavior are explicit and predictable.
- [ ] Text is always inside `<text>`, with modifiers only inside `<text>`.
- [ ] The design considers small terminals and resize behavior.
- [ ] Performance hot paths (logs, large lists) are treated specially.
- [ ] Production use is called out explicitly with caveats if applicable.

Use this reference to keep designs practical, robust, and aligned with OpenTUI's strengths and limitations.
