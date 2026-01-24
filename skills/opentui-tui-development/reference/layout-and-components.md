# Layout and Core Components

This reference covers the main layout primitives and Yoga-based properties used throughout OpenTUI.

## Layout model

OpenTUI attaches a **Yoga flexbox layout** node to every `Renderable`. You configure layout via props instead of CSS.

Important categories:

- **Flex container props**
  - `flexDirection`: `row | column | row-reverse | column-reverse`
  - `flexWrap`: `nowrap | wrap | wrap-reverse`
  - `alignItems`: `flex-start | center | flex-end | stretch`
  - `justifyContent`: `flex-start | center | flex-end | space-between | space-around`
- **Flex child props**
  - `flexGrow`, `flexShrink`: numbers controlling how children expand or shrink.
  - `flexBasis`: `number | "auto"` – starting size before flexing.
  - `alignSelf`: overrides `alignItems` per child.
- **Sizing**
  - `width`, `height`, `minWidth`, `maxWidth`, `minHeight`, `maxHeight`.
  - Accept `number` (cells), `"auto"`, or percentage strings like `"50%"`.
- **Positioning & spacing**
  - `position`: `relative | absolute`.
  - `top`, `right`, `bottom`, `left`: offsets.
  - `margin*` and `padding*` in cells or percentages.
- **Overflow**
  - `overflow`: `visible | hidden | scroll`.

Always design in terms of **terminal cells**, not pixels. A width of `40` means 40 characters, not 40 CSS pixels.

## Box: the primary container

`BoxRenderable` (JSX: `<box>`) is the standard building block for layout.

Key options (often set as props or via the `style` prop):

- Visuals
  - `border: boolean` – draw a Unicode border.
  - `borderStyle: "single" | "double" | "rounded"`.
  - `borderColor`, `focusedBorderColor`.
  - `backgroundColor`.
  - `title`, `titleAlignment: "left" | "center" | "right"`.
- Spacing
  - `padding`, `paddingTop`, `paddingRight`, etc.
- Layout
  - All Yoga props listed above (`flexDirection`, `flexGrow`, `width`, etc.).

Typical patterns:

- App shells built from nested `<box>` containers (header, sidebar, content, status bar).
- Dialogs and panels with titles and padding.

## Group: layout-only container

`GroupRenderable` is a **non-visual** container used for layout only.

Use `<group>` (or the equivalent in your framework) when you need to:

- Group children for flex layout.
- Avoid extra borders or backgrounds.
- Keep the visual hierarchy simple while still structuring the layout tree.

## ScrollBox: scrollable content

`ScrollBoxRenderable` (JSX: `<scrollbox>`) is a composite component for scrollable regions.

High-level structure:

1. Root `ScrollBoxRenderable` – top-level container, may show vertical scrollbar.
2. Wrapper `BoxRenderable` – contains viewport and optional horizontal scrollbar.
3. Viewport `BoxRenderable` – clipping region with `overflow: hidden`.
4. Content container – translated according to scroll offsets.

Important options:

- `rootOptions`, `wrapperOptions`, `viewportOptions`, `contentOptions`: nested `BoxOptions` for styling each layer.
- `scrollY`, `scrollX`: booleans controlling which axes can scroll.
- `stickyScroll`: keep the viewport pinned to an edge when content grows (useful for logs/chat).
- `viewportCulling`: when `true` (default), only visible children are rendered/hit-tested.
- `scrollAcceleration`: e.g. `LinearScrollAccel` or `MacOSScrollAccel` for momentum.

Patterns:

- **Log viewers and chat windows** – enable `stickyScroll` at the bottom so new lines remain visible until the user scrolls away.
- **Virtualized lists** – render hundreds or thousands of rows with `viewportCulling` for performance.

## Text and modifiers

OpenTUI distinguishes between **text components** and **modifiers**.

- `<text>`: owns text layout and styling.
- Modifiers: `<span>`, `<strong>`, `<em>`, `<u>`, `<b>`, `<i>`, `<br>` – used **inside** `<text>` only.

Guidelines:

- Always wrap textual content in `<text>`.
- Use modifiers for inline styling, not layout.
- Keep deeply nested text structures small; prefer several simple `<text>` blocks.

## Input and selection components (React layer)

Common interactive components exposed via `@opentui/react`:

- `<input>` – single-line text field.
  - `placeholder`, `onInput(value)`, `onSubmit(value)`, `focused`.
- `<textarea>` – multi-line editor.
  - Works well with keyboard hooks for enter/submit behavior.
- `<select>` – list/option selection.
  - `options`, `onChange(index, option)`, `focused`, optional scroll indicators.
- `<tab-select>` – tabbed selection.

Design principles:

- Only one interactive widget should be `focused={true}` at a time.
- Use `useKeyboard` for **global** shortcuts and navigation; use component props for per-widget actions.

## Code and diff components

For code-heavy tools, OpenTUI provides:

- `<code>` – syntax-highlighted code blocks.
- `<line-number>` – wraps `<code>` to add line numbers, diff highlights, and diagnostics.
- `<diff>` – unified or split code diff viewer.

Use cases:

- In-terminal code review tools.
- Debugging dashboards that show logs, traces, or code excerpts.
- Editors that need diagnostics and inline annotations.

When designing UIs using these components, plan:

- How much code fits comfortably in the viewport.
- How scrolling and navigation will work.
- How diagnostics or diff markers map to keyboard interactions.

Use this reference when you need low-level detail about how to structure an OpenTUI layout and which core components to choose for a given task.
