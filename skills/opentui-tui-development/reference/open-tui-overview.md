# OpenTUI Overview

## What OpenTUI is

OpenTUI is an experimental TypeScript + Zig framework for building **terminal user interfaces (TUIs)**.

Key properties:

- **Character-grid rendering** – everything is rendered into terminal cells, not pixels.
- **Core + reconcilers** architecture:
  - `@opentui/core`: imperative renderable primitives and Zig-backed renderer.
  - `@opentui/react`: React reconciler.
  - `@opentui/solid`: SolidJS reconciler.
- **Yoga-based flex layout** – all containers share a common flexbox-like layout engine.

OpenTUI is explicitly marked **not ready for production** at the time of writing. Treat it as a powerful toolkit for:

- Internal tools and dashboards.
- Prototypes and experiments.
- Agentic coding flows and debugging consoles.

## Packages and roles

- `@opentui/core`
  - `CliRenderer` – manages terminal rendering, dimensions, and input.
  - `Renderable` hierarchy – base class for all visual and interactive elements.
  - Zig native library – implements high-performance buffer, diffing, and ANSI output.
- `@opentui/react`
  - Custom React reconciler that maps JSX elements to `Renderable` instances.
  - Component catalogue: tags like `<box>`, `<text>`, `<scrollbox>`, `<input>`, `<code>`, `<line-number>`, `<diff>`.
  - Hooks for renderer access, keyboard events, terminal dimensions, and animations.
- `@opentui/solid`
  - SolidJS-specific reconciler following the same catalogue pattern as React.

## Mental model

- Think of OpenTUI as **React for the terminal**, but remember the target is a **text grid**, not a browser.
- Layout, colors, and borders are controlled via **props**, not CSS.
- The reconciler translates React tree updates into calls to the underlying `Renderable` API.
- Performance-critical operations (diffing, buffer manipulation) live in Zig and are exposed through FFI.

## When to use OpenTUI

Good fits:

- Interactive CLI tools that need more structure than simple stdin/stdout.
- Dashboards, monitors, and inspectors for services and agents.
- Developer tools that should run over SSH or in constrained environments.

Avoid for now:

- Customer-facing, high-stakes production systems.
- Workloads that need rock-solid cross-terminal compatibility and long-term maintenance guarantees.

## Core trade-offs

**Pros:**

- Rich, composable UI primitives in the terminal.
- Familiar component patterns via React or Solid.
- High-performance rendering through native code.

**Cons / risks:**

- Experimental project: versioning and license stability still evolving.
- Requires Zig and bun for local development and builds.
- Terminal rendering is inherently less predictable than browsers (different emulators, fonts, color capabilities).

Use this reference when deciding whether OpenTUI is appropriate for a given project, and when you need to explain its architecture to a developer who knows React and Node but is new to TUIs.
