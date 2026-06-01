#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage: scripts/init-links.sh [--replace]

Links this repository's skills/ directory into Codex home:
  ${CODEX_HOME:-$HOME/.codex}/skills

Options:
  --replace   Move an existing ~/.codex/skills path to a timestamped backup first.
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
source_skills="$repo_root/skills"

if [ ! -d "$source_skills" ]; then
  echo "Missing source skills directory: $source_skills" >&2
  exit 1
fi

codex_home="${CODEX_HOME:-$HOME/.codex}"
target="$codex_home/skills"

mkdir -p "$codex_home"

if [ -L "$target" ]; then
  current=$(readlink "$target")
  if [ "$current" = "$source_skills" ]; then
    echo "Already linked: $target -> $source_skills"
    exit 0
  fi

  if [ "$replace" != true ]; then
    echo "Refusing to replace existing symlink: $target -> $current" >&2
    echo "Run with --replace to back it up and relink." >&2
    exit 1
  fi
fi

if [ -e "$target" ] || [ -L "$target" ]; then
  if [ "$replace" != true ]; then
    echo "Refusing to replace existing path: $target" >&2
    echo "Run with --replace to back it up and relink." >&2
    exit 1
  fi

  backup="$target.backup.$(date +%Y%m%d%H%M%S)"
  mv "$target" "$backup"
  echo "Backed up existing skills path to: $backup"
fi

ln -s "$source_skills" "$target"
echo "Linked: $target -> $source_skills"

