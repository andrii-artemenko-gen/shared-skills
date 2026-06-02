#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage: scripts/init-links.sh [--replace]

Links this repository's .agents skills and scripts directories into Codex home:
  ${CODEX_HOME:-$HOME/.codex}/skills
  ${CODEX_HOME:-$HOME/.codex}/scripts

Options:
  --replace   Move existing target paths to timestamped backups first.
  -h, --help  Show this help.
EOF
}

replace=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --replace)
      replace=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
repo_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
source_skills="$repo_root/.agents/skills"
source_scripts="$repo_root/.agents/scripts"

if [ ! -d "$source_skills" ]; then
  echo "Missing source skills directory: $source_skills" >&2
  exit 1
fi

if [ ! -d "$source_scripts" ]; then
  echo "Missing source scripts directory: $source_scripts" >&2
  exit 1
fi

codex_home="${CODEX_HOME:-$HOME/.codex}"
target_skills="$codex_home/skills"
target_scripts="$codex_home/scripts"

mkdir -p "$codex_home"

link_target() {
  source_path="$1"
  target_path="$2"

  if [ -L "$target_path" ]; then
    current=$(readlink "$target_path")
    if [ "$current" = "$source_path" ]; then
      echo "Already linked: $target_path -> $source_path"
      return 0
    fi

    if [ "$replace" != true ]; then
      echo "Refusing to replace existing symlink: $target_path -> $current" >&2
      echo "Run with --replace to back it up and relink." >&2
      exit 1
    fi
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    if [ "$replace" != true ]; then
      echo "Refusing to replace existing path: $target_path" >&2
      echo "Run with --replace to back it up and relink." >&2
      exit 1
    fi

    backup="$target_path.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target_path" "$backup"
    echo "Backed up existing path to: $backup"
  fi

  ln -s "$source_path" "$target_path"
  echo "Linked: $target_path -> $source_path"
}

link_target "$source_skills" "$target_skills"
link_target "$source_scripts" "$target_scripts"
