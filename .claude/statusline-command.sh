#!/bin/bash
# Status line mirroring the oh-my-zsh "robbyrussell" prompt:
#   ➜  <dir> git:(<branch>) ✗
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
dir=$(basename "$cwd")
model=$(echo "$input" | jq -r '.model.display_name // empty')

out=$(printf '\033[1;32m➜\033[0m  \033[36m%s\033[0m' "$dir")

branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
  || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  out="$out$(printf ' \033[1;34mgit:(\033[0;31m%s\033[1;34m)\033[0m' "$branch")"
  if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null | head -n1)" ]; then
    out="$out$(printf ' \033[33m✗\033[0m')"
  fi
fi

[ -n "$model" ] && out="$out$(printf ' \033[2m[%s]\033[0m' "$model")"
printf '%s' "$out"
