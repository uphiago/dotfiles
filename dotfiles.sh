#!/usr/bin/env bash

REPO="$HOME/Repositories/devops/dotfiles"

[ ! -d "$REPO/.git" ] && echo "Not a valid Git repo: $REPO" && exit 1

cd "$REPO" || exit 1

git pull --rebase origin main

git add .
git commit -m "Auto-update $(date +%F_%T)" || true

git push origin main
