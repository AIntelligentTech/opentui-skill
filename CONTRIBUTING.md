# Contributing to OpenTUI Skill

**Version:** 1.0
**Last Updated:** 2026-01-24
---

Thanks for your interest in improving the OpenTUI Skill toolkit. This repo is designed to be:

- A high-quality, open-source **Claude Code skill** collection for OpenTUI.
- Safe and predictable for users (installer is conservative and idempotent).
- Easy to contribute to with clear workflows and expectations.

This document summarizes how to propose changes, structure branches/commits, and validate updates.

## 1. Scope of this repository

This repo currently contains:

- **Claude Code skills** under `skills/` (e.g. `opentui-tui-development`, `opentui-layout-review`).
- **Reference documentation** used by those skills under `skills/*/reference/`.
- A **versioned installer** (`install.sh`) for user- and project-level installs.
- Standard OSS boilerplate: `LICENSE`, `SECURITY.md`, `CODE_OF_CONDUCT.md`, `CONTRIBUTING.md`, `CHANGELOG.md`.

Contributions typically fall into one of these categories:

- New or improved **skills**.
- Refined **reference docs** and checklists.
- Enhancements or bugfixes to the **installer**.
- Documentation and governance improvements.

## 2. Getting started

1. **Fork and clone** the repository (or create a feature branch locally if you have direct access).
2. Ensure you have a POSIX shell with `bash` and access to your home directory.
3. From the repo root, you can test installation into a scratch project:

   ```bash
   # From opentui-skill/
   ./install.sh --level project --project-dir /path/to/test-project --dry-run
   ./install.sh --level project --project-dir /path/to/test-project
   ```

4. In that project, open Claude Code and verify that the expected skills are available under `/`.

## 3. Branching and commit style

Follow a simple, trunk-based workflow:

- Create short-lived feature branches:
  - `feature/opentui-layout-review-checklists`
  - `fix/installer-detect-only`
  - `docs/update-opentui-skill-readme`
- Keep branches focused on a single logical change.

Use **Conventional Commits-style** messages:

- `feat(skill): add opentui-layout-review Claude skill`
- `fix(installer): handle missing VERSION file gracefully`
- `docs: clarify user vs project installation in README`
- `chore: update tooling and ignore patterns`

## 4. Making changes

### 4.1 Skills (`skills/<name>/SKILL.md`)

When you add or modify a skill:

- Ensure the `SKILL.md` frontmatter follows Claude guidelines:
  - `name`: lowercase letters / digits / hyphens, max 64 chars.
  - `description`: concise, third-person, explains **what** and **when**.
  - `disable-model-invocation`, `user-invocable` set intentionally.
- Keep `SKILL.md` **under ~500 lines** and use **progressive disclosure**:
  - Put deep detail into `reference/*.md` files.
  - Link to them from `SKILL.md` when needed.
- Use **workflow-style sections** and checklists for complex tasks.
- Prefer concrete, implementation-ready instructions over vague advice.

### 4.2 Reference documentation

- Organize reference files under `skills/<name>/reference/`.
- Use clear headings and short sections.
- Avoid re-explaining generic web/React or terminal basics unless they are directly relevant to OpenTUI.
- Keep examples small and focused; avoid full applications in a single doc.

### 4.3 Installer (`install.sh`)

If you change `install.sh`:

- Preserve these guarantees:
  - **Idempotent**: re-running the same command should be safe.
  - **Scoped**: only touches `.claude/skills` directories and version files.
  - **Dry-run** and `--detect-only` must never modify the filesystem.
- Keep behavior symmetric for project and user levels.
- Add or update usage examples in `usage()` and the `README.md` when flags change.

## 5. Testing your changes

Before opening a PR or sharing patches:

1. **Lint and format** any scripts or config you change (if applicable in your environment).
2. **Manual skill validation**:
   - Install skills into a sample project and/or user-level location.
   - Confirm that new skills appear under `/` in Claude Code.
   - Trigger each skill and verify that workflows and references behave as expected.
3. **Installer safety**:
   - Run `./install.sh --level user --detect-only --dry-run`.
   - Test `--uninstall --dry-run` in both project and user modes.

## 6. Submitting changes

If this repo is hosted on GitHub:

1. Push your feature branch.
2. Open a Pull Request against `main`.
3. In the PR description, include:
   - A short summary of the change.
   - Any behavioral changes to skills or installer.
   - Notes on testing (what you ran, platforms used).

Expect review to focus on:

- Clarity and correctness of skill instructions.
- Safety and predictability of the installer.
- Consistency with existing patterns and terminology.

## 7. Code of Conduct and Security

By participating in this project, you agree to follow the:

- [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md)
- [`SECURITY.md`](./SECURITY.md)

If you observe behavior that violates the Code of Conduct or discover a potential security issue, please follow the guidance in those documents.
