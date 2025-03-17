#!/usr/bin/env bash

REPO="$HOME/Repositories/devops/dotfiles"
ZSH="$REPO/.zshrc"
ALA="$REPO/alacritty.toml"
FFC="$REPO/config.jsonc"

git config --global --add safe.directory "$REPO"

[ ! -d "$REPO" ] && echo "Repo not found: $REPO" && exit 1

cd "$REPO"
git pull origin main

ln -sf "$ZSH" "$HOME/.zshrc"
mkdir -p "$HOME/.config/alacritty"
ln -sf "$ALA" "$HOME/.config/alacritty/alacritty.yml"
mkdir -p "$HOME/.config/fastfetch"
ln -sf "$FFC" "$HOME/.config/fastfetch/config.jsonc"

git add .
git commit -m "Update dotfiles $(date +%F_%T)"
git push origin main
