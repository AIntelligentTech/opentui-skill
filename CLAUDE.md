# Using OpenTUI Skills with Claude Code

**Version:** 1.0
**Last Updated:** 2026-01-24
---

This repository provides **Claude Code skills** focused on OpenTUI-based terminal UI development.

## Skills provided

The toolkit currently includes these skills:

- `/opentui-tui-development`
  - Designs and implements OpenTUI-based TUIs using best-practice layouts, components, and React integration.
- `/opentui-layout-review`
  - Performs a structured review of an existing OpenTUI layout, calling out strengths, issues, and concrete improvements.

Both skills are user-invocable and disabled for automatic model invocation by default.

## Installation locations

Skills can be installed at:

- **User level**: `~/.claude/skills/<skill-name>/SKILL.md`
- **Project level**: `<project>/.claude/skills/<skill-name>/SKILL.md`

Project-level skills override user-level ones with the same name.

## Installing via `install.sh`

From the `opentui-skill/` directory:

```bash
# User-level install (recommended for general use)
./install.sh --level user

# Project-level install into the current directory
./install.sh --level project

# Project-level install into a specific project directory
./install.sh --level project --project-dir /path/to/project
```

Use `--dry-run` to preview changes, and `--uninstall` to remove installed skills. See `README.md` for full usage.

## Usage patterns

### `/opentui-tui-development`

Use this skill when you are:

- Designing a new OpenTUI screen or app shell.
- Deciding how to structure boxes, scrollboxes, and panels.
- Integrating OpenTUI with React (`@opentui/react`) or deciding when to use `@opentui/core` directly.

Example invocations:

```text
/opentui-tui-development Design a dashboard for monitoring background workers with a header, sidebar, and main log view.

/opentui-tui-development Help me port this React web layout to OpenTUI while keeping the information hierarchy intact.
```

### `/opentui-layout-review`

Use this skill when you already have an OpenTUI layout or plan and want a structured critique.

```text
/opentui-layout-review Review the layout of my OpenTUI Git client and suggest improvements to navigation and small-terminal behavior.

/opentui-layout-review I’ll paste my current JSX for the main screen; please identify layout smells, focus issues, and scroll problems.
```

## Best practices

- Provide **code snippets** or clear descriptions of screens, not entire applications at once.
- Mention whether you’re using **React**, **Solid**, or `@opentui/core` directly.
- Call out constraints such as minimum terminal size, performance requirements, or accessibility needs.

These skills are designed to be **advisory** and **design-focused**; they do not execute code or modify your filesystem.
