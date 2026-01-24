#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SKILLS_ROOT="$SCRIPT_DIR/skills"
VERSION_FILE="$SCRIPT_DIR/VERSION"
TOOLKIT_VERSION="$(cat "$VERSION_FILE" 2>/dev/null || echo "0.0.0")"

usage() {
  cat <<USAGE
Usage: $SCRIPT_NAME --level <level> [--project-dir <dir>] [--force] [--dry-run] [--uninstall] [--detect-only] [--yes]

Levels:
  project         Install into the specified project (default: current directory)
  user            Install into user-level Claude Code skills (~/.claude/skills)

Options:
  --project-dir <dir>  Project root to use for project-level installs (default: current directory)
  --force              Overwrite any existing opentui-skill installation at the destination
  --dry-run            Print what would be done without making any filesystem changes
  --uninstall          Uninstall opentui-skill artifacts for the selected level instead of installing
  --detect-only        Detect and report existing installations for the selected level without changing the filesystem
  --yes, --non-interactive
                       Do not prompt for confirmation during uninstall; assume "yes" to prompts

Examples:
  # Install OpenTUI skills into the current project (.claude/skills)
  $SCRIPT_NAME --level project

  # Install OpenTUI skills into a specific project directory
  $SCRIPT_NAME --level project --project-dir /path/to/project

  # Install OpenTUI skills into user-level Claude skills (~/.claude/skills)
  $SCRIPT_NAME --level user

  # Detect existing installations at the user level
  $SCRIPT_NAME --level user --detect-only

  # Uninstall from user-level skills non-interactively
  $SCRIPT_NAME --level user --uninstall --yes
USAGE
}

prompt_confirm() {
  local message="$1"
  if [ "${YES:-false}" = true ] || [ "${DRY_RUN:-false}" = true ]; then
    return 0
  fi
  printf "%s [y/N] " "$message" >&2
  # shellcheck disable=SC2162
  read reply || return 1
  case "$reply" in
    y|Y|yes|YES)
      return 0
      ;;
    *)
      echo "[info] operation cancelled by user" >&2
      return 1
      ;;
  esac
}

install_to() {
  local dest_root="$1"
  local label="$2"
  local version_file="$dest_root/.opentui-skill-version"

  if [ ! -d "$SKILLS_ROOT" ]; then
    echo "[error] skills root directory not found: $SKILLS_ROOT" >&2
    exit 1
  fi

  if [ -f "$version_file" ] && [ "${FORCE:-false}" != "true" ]; then
    local existing
    existing="$(cat "$version_file" 2>/dev/null || echo "unknown")"
    if [ "${DRY_RUN:-false}" = true ]; then
      echo "[dry-run] would detect existing opentui-skill version $existing in $dest_root ($label); rerun with --force to overwrite."
    else
      echo "[info] existing opentui-skill version $existing detected in $dest_root ($label); use --force to overwrite." >&2
    fi
    return 0
  fi

  shopt -s nullglob
  local skill_src_dirs=("$SKILLS_ROOT"/*)
  if [ "${#skill_src_dirs[@]}" -eq 0 ]; then
    echo "[warn] no skills found under $SKILLS_ROOT; nothing to install" >&2
  fi

  if [ "${DRY_RUN:-false}" = true ]; then
    echo "[dry-run] would ensure directory exists: $dest_root"
  else
    mkdir -p "$dest_root"
  fi

  for skill_src_dir in "${skill_src_dirs[@]}"; do
    if [ ! -d "$skill_src_dir" ]; then
      continue
    fi
    local name
    name="$(basename "$skill_src_dir")"
    local dest_skill_dir="$dest_root/$name"

    if [ "${DRY_RUN:-false}" = true ]; then
      echo "[dry-run] would ensure directory exists: $dest_skill_dir"
      echo "[dry-run] would install skill $name -> $dest_skill_dir"
    else
      mkdir -p "$dest_skill_dir"
      cp -R "$skill_src_dir"/. "$dest_skill_dir"/
      echo "[ok] installed skill $name -> $dest_skill_dir"
    fi
  done

  if [ "${DRY_RUN:-false}" = true ]; then
    echo "[dry-run] would record toolkit version $TOOLKIT_VERSION in $version_file"
  else
    echo "$TOOLKIT_VERSION" >"$version_file"
  fi
}

uninstall_from() {
  local dest_root="$1"
  local label="$2"
  local version_file="$dest_root/.opentui-skill-version"

  if [ ! -d "$dest_root" ]; then
    echo "[info] no Claude skills directory found at $dest_root ($label); nothing to do."
    return 0
  fi

  if [ -f "$version_file" ]; then
    local existing
    existing="$(cat "$version_file" 2>/dev/null || echo "unknown")"
    echo "[info] detected opentui-skill version $existing in $dest_root ($label)."
  else
    echo "[info] no .opentui-skill-version found in $dest_root ($label); will still look for opentui-* skill directories."
  fi

  shopt -s nullglob
  local skill_dirs=("$dest_root"/opentui-*)
  local found=false

  echo "[info] the following items would be removed from $dest_root ($label) if present:"
  for sd in "${skill_dirs[@]}"; do
    if [ -d "$sd" ]; then
      found=true
      echo "  - $(basename "$sd")/"
    fi
  done
  if [ -f "$version_file" ]; then
    found=true
    echo "  - .opentui-skill-version"
  fi

  if [ "$found" = false ]; then
    echo "[info] no opentui-* skills or version file found in $dest_root ($label); nothing to uninstall."
    return 0
  fi

  if [ "$MODE" = "detect" ]; then
    return 0
  fi

  if ! prompt_confirm "Proceed with uninstall from $dest_root ($label)?"; then
    return 0
  fi

  if [ "${DRY_RUN:-false}" = true ]; then
    for sd in "${skill_dirs[@]}"; do
      if [ -d "$sd" ]; then
        echo "[dry-run] would remove directory $sd"
      fi
    done
    if [ -f "$version_file" ]; then
      echo "[dry-run] would remove $version_file"
    fi
  else
    for sd in "${skill_dirs[@]}"; do
      if [ -d "$sd" ]; then
        rm -rf "$sd"
        echo "[ok] removed directory $sd"
      fi
    done
    if [ -f "$version_file" ]; then
      rm -f "$version_file"
      echo "[ok] removed $version_file"
    fi
  fi
}

if [ "$#" -eq 0 ]; then
  usage
  exit 0
fi

LEVEL=""
PROJECT_DIR="$PWD"
FORCE=false
DRY_RUN=false
UNINSTALL=false
DETECT_ONLY=false
YES=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --level)
      LEVEL="${2:-}"
      shift 2
      ;;
    --project-dir)
      PROJECT_DIR="${2:-}"
      shift 2
      ;;
    --force|--overwrite)
      FORCE=true
      shift 1
      ;;
    --dry-run)
      DRY_RUN=true
      shift 1
      ;;
    --uninstall)
      UNINSTALL=true
      shift 1
      ;;
    --detect-only)
      DETECT_ONLY=true
      shift 1
      ;;
    --yes|--non-interactive)
      YES=true
      shift 1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[error] unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [ -z "$LEVEL" ]; then
  echo "[error] --level is required" >&2
  usage
  exit 1
fi

if [ "$LEVEL" = "project" ] && [ "$PROJECT_DIR" = "/" ]; then
  echo "[error] refusing to install into project-dir '/' (this is almost certainly unintended)." >&2
  exit 1
fi

MODE="install"
if [ "$DETECT_ONLY" = true ]; then
  MODE="detect"
elif [ "$UNINSTALL" = true ]; then
  MODE="uninstall"
fi

echo "[info] level=$LEVEL project_dir=$PROJECT_DIR force=$FORCE dry_run=$DRY_RUN mode=$MODE"
if [ "$DRY_RUN" = true ]; then
  echo "[info] running in dry-run mode; no filesystem changes will be made."
fi

case "$LEVEL" in
  project)
    DEST_ROOT="$PROJECT_DIR/.claude/skills"
    ;;
  user)
    DEST_ROOT="$HOME/.claude/skills"
    ;;
  *)
    echo "[error] unsupported level: $LEVEL" >&2
    usage
    exit 1
    ;;
esac

if [ "$MODE" = "install" ]; then
  install_to "$DEST_ROOT" "$LEVEL"
else
  uninstall_from "$DEST_ROOT" "$LEVEL"
fi
