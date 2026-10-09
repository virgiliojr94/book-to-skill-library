#!/usr/bin/env bash
# Symlinka todas as skills deste repo nos diretórios de skill dos agents.
set -euo pipefail
R="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TARGETS=(
  "$HOME/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.config/opencode/skills"
)

for src in "$R"/books/*/ "$R"/x/*/; do
  [ -f "$src/SKILL.md" ] || continue
  name=$(basename "$src")
  for t in "${TARGETS[@]}"; do
    [ -d "$t" ] || continue
    dst="$t/$name"
    if [ -L "$dst" ]; then
      ln -sfn "${src%/}" "$dst"
    elif [ -e "$dst" ]; then
      echo "skip (dir real existe): $dst" >&2
      continue
    else
      ln -s "${src%/}" "$dst"
    fi
    echo "linked $dst"
  done
done
