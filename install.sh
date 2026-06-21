#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${SKILLS_REPO_URL:-https://github.com/moycat/skills.git}"
INSTALL_DIR="${SKILLS_INSTALL_DIR:-$HOME/.local/share/moycat-skills}"
HARNESS="${SKILLS_HARNESS:-${1:-auto}}"

usage() {
  cat <<'EOF'
Usage:
  SKILLS_HARNESS=<codex|claude|opencode|all> bash install.sh

Environment:
  SKILLS_REPO_URL      Git repository to clone. Defaults to https://github.com/moycat/skills.git
  SKILLS_INSTALL_DIR   Clone/update location. Defaults to ~/.local/share/moycat-skills
  SKILLS_HARNESS       Target harness: codex, claude, opencode, all, or auto
EOF
}

die() {
  printf 'install.sh: %s\n' "$*" >&2
  exit 1
}

absolute_path_for_new_dir() {
  local dir="$1"
  local parent
  local base

  parent="$(dirname "$dir")"
  base="$(basename "$dir")"
  mkdir -p "$parent"
  parent="$(cd "$parent" && pwd -P)"
  printf '%s/%s\n' "$parent" "$base"
}

detect_harness() {
  if [ -n "${CLAUDECODE:-}" ] || [ -n "${CLAUDE_CODE:-}" ] || [ -n "${CLAUDE_SESSION_ID:-}" ]; then
    printf 'claude\n'
    return
  fi

  if [ -n "${OPENCODE:-}" ] || [ -n "${OPENCODE_SESSION_ID:-}" ]; then
    printf 'opencode\n'
    return
  fi

  if [ -n "${CODEX_HOME:-}" ] || [ -n "${CODEX_SANDBOX:-}" ] || [ -n "${OPENAI_CODEX:-}" ]; then
    printf 'codex\n'
    return
  fi

  return 1
}

target_dirs_for_harness() {
  case "$1" in
    codex)
      printf '%s\n' "$HOME/.agents/skills"
      ;;
    claude)
      printf '%s\n' "$HOME/.claude/skills"
      ;;
    opencode)
      printf '%s\n' "$HOME/.config/opencode/skills"
      ;;
    all)
      printf '%s\n' "$HOME/.agents/skills"
      printf '%s\n' "$HOME/.claude/skills"
      printf '%s\n' "$HOME/.config/opencode/skills"
      ;;
    *)
      return 1
      ;;
  esac
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$HARNESS" = "auto" ]; then
  HARNESS="$(detect_harness || true)"
  if [ -z "$HARNESS" ]; then
    die "could not auto-detect harness; set SKILLS_HARNESS=codex, claude, opencode, or all"
  fi
fi

TARGET_DIRS=()
while IFS= read -r target_dir; do
  TARGET_DIRS+=("$target_dir")
done < <(target_dirs_for_harness "$HARNESS") || true

if [ "${#TARGET_DIRS[@]}" -eq 0 ]; then
  usage >&2
  die "unsupported harness: $HARNESS"
fi

INSTALL_DIR="$(absolute_path_for_new_dir "$INSTALL_DIR")"

if [ -d "$INSTALL_DIR/.git" ]; then
  git -C "$INSTALL_DIR" pull --ff-only
elif [ -e "$INSTALL_DIR" ]; then
  die "$INSTALL_DIR exists but is not a git checkout"
else
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

SKILLS_DIR="$INSTALL_DIR/skills"
[ -d "$SKILLS_DIR" ] || die "$SKILLS_DIR does not exist"

shopt -s nullglob
SKILL_DIRS=()
for skill_file in "$SKILLS_DIR"/*/SKILL.md; do
  SKILL_DIRS+=("$(dirname "$skill_file")")
done
shopt -u nullglob

if [ "${#SKILL_DIRS[@]}" -eq 0 ]; then
  printf 'No skills found in %s. Repository installed, but no skill links were created.\n' "$SKILLS_DIR"
  exit 0
fi

CONFLICTS=()
for target_dir in "${TARGET_DIRS[@]}"; do
  for skill_dir in "${SKILL_DIRS[@]}"; do
    link_path="$target_dir/$(basename "$skill_dir")"
    if [ -L "$link_path" ]; then
      if [ "$(readlink "$link_path")" = "$skill_dir" ]; then
        continue
      fi
      CONFLICTS+=("$link_path")
    elif [ -e "$link_path" ]; then
      CONFLICTS+=("$link_path")
    fi
  done
done

if [ "${#CONFLICTS[@]}" -gt 0 ]; then
  printf 'Refusing to overwrite existing skill paths:\n' >&2
  printf '  %s\n' "${CONFLICTS[@]}" >&2
  exit 1
fi

for target_dir in "${TARGET_DIRS[@]}"; do
  mkdir -p "$target_dir"
  for skill_dir in "${SKILL_DIRS[@]}"; do
    link_path="$target_dir/$(basename "$skill_dir")"
    if [ -L "$link_path" ]; then
      continue
    fi
    ln -s "$skill_dir" "$link_path"
  done
done

skill_count="${#SKILL_DIRS[@]}"
if [ "$skill_count" -eq 1 ]; then
  printf 'Installed 1 skill for %s.\n' "$HARNESS"
else
  printf 'Installed %s skills for %s.\n' "$skill_count" "$HARNESS"
fi

printf 'Repository: %s\n' "$INSTALL_DIR"
printf 'Targets:\n'
printf '  %s\n' "${TARGET_DIRS[@]}"
