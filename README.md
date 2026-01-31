# OpenTUI Skills for Claude Code

A small suite of portable Claude Code skills that encode best practices for building and reviewing **OpenTUI**-based terminal user interfaces (TUIs).

This repository is modeled after `agent-deep-toolkit`:

- Focused scope: provides opinionated **OpenTUI development and layout review skills** for Claude Code.
- Installable at **user** or **project** level via a small `install.sh` script.
- Safe and conservative: installer only copies markdown skill files and writes a version marker.

For a Claude-specific overview and usage examples, see [`CLAUDE.md`](./CLAUDE.md).

## Repository layout

```text
opentui-skill/
  README.md          # This file (overview and usage)
  LICENSE            # MIT license
  VERSION            # Semantic version for this toolkit
  .gitignore         # Basic ignores
  install.sh         # Installer / uninstaller for Claude Code skills
  CONTRIBUTING.md    # Contribution guidelines
  CODE_OF_CONDUCT.md # Community expectations and enforcement
  SECURITY.md        # Security and responsible disclosure policy
  CLAUDE.md          # How to use these skills from Claude Code
  CHANGELOG.md       # Notable changes per release

  skills/
    opentui-tui-development/
      SKILL.md                       # Main OpenTUI development skill
      reference/
        open-tui-overview.md         # High-level concepts and mental model
        layout-and-components.md     # Layout system, Box/Scrollbox, Yoga props
        react-integration.md         # React reconciler, hooks, timelines
        patterns-and-pitfalls.md     # Patterns, examples, common mistakes

    opentui-layout-review/
      SKILL.md                       # Structured layout review skill
      reference/
        opentui-layout-review-guide.md  # Detailed review patterns and checklist
```

## Installing the OpenTUI skill

The installer supports **user-level** and **project-level** installs for Claude Code.

> Requirements: POSIX shell with `bash` available via `/usr/bin/env bash`, and access to your home directory for user-level installs.

### Project-level install

From the `opentui-skill/` directory:

```bash
# Install into the current project (.claude/skills)
./install.sh --level project

# Or install into a specific project directory
./install.sh --level project --project-dir /path/to/project
```

This will, for **each skill directory under `skills/`** (for example `opentui-tui-development`, `opentui-layout-review`):

- Create `<project>/.claude/skills/<skill-name>/`.
- Copy the `SKILL.md` and any `reference/` files.
- Write a `.opentui-skill-version` file into `<project>/.claude/skills/` with the toolkit version.

### User-level install

```bash
# Install into your user-level Claude skills (~/.claude/skills)
./install.sh --level user
```

This will, for **each skill directory under `skills/`**:

- Create `~/.claude/skills/<skill-name>/`.
- Copy the `SKILL.md` and `reference/` files.
- Write `~/.claude/skills/.opentui-skill-version` recording the installed version.

### Dry run and detection

The installer is intentionally conservative and supports read-only modes:

```bash
# Show what would be installed without touching the filesystem
./install.sh --level user --dry-run

# Detect existing installations without changing anything
./install.sh --level user --detect-only
```

### Uninstalling

```bash
# Uninstall from user-level skills
./install.sh --level user --uninstall --yes

# Uninstall from a specific project
./install.sh --level project --project-dir /path/to/project --uninstall
```

Uninstall mode removes:

- Any `opentui-*` skill directories under the relevant `.claude/skills/` root.
- The `.opentui-skill-version` marker file (for the selected level).

## Using the skills in Claude Code

Once installed, Claude Code will discover the skills automatically:

- Project-level: `<project>/.claude/skills/<skill-name>/SKILL.md`
- User-level: `~/.claude/skills/<skill-name>/SKILL.md`

The toolkit currently provides:

- `/opentui-tui-development` – design and implementation help for OpenTUI TUIs.
- `/opentui-layout-review` – structured review of existing OpenTUI layouts.

See [`CLAUDE.md`](./CLAUDE.md) for concrete invocation examples and usage patterns.

## Versioning

The toolkit follows [Semantic Versioning](https://semver.org/). The canonical version is stored in the top-level `VERSION` file.

Each destination directory that the installer manages also receives a `.opentui-skill-version` file. Re-running the installer:

- Is **idempotent** by default: if the version file already exists and `--force` is not set, the installer logs an informational message and skips overwriting.
- Can be forced with `--force` to replace an existing installation.

To upgrade an existing installation to a newer version:

1. Update your local `opentui-skill` checkout to the desired version (for example via `git checkout v0.1.0` once tags exist).
2. Re-run the same `install.sh` command you used originally.

## Git and contribution guidelines (high level)

- Keep commits **small and focused**, following a Conventional Commits-style convention:
  - `feat(opentui-skill): ...`, `fix(installer): ...`, `docs: ...`, etc.
- Prefer feature branches like `feature/opentui-skill-initial` and clean PRs over direct pushes to `main`.
- Include updates to SKILL and reference docs in the **same PR** as behavior changes.

See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for detailed contribution and review expectations.
# CI/CD Status
