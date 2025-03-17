#!/usr/bin/env bash
set -euo pipefail

REPO="$HOME/Repositories/devops/dotfiles"

# Paths: Home and Repo versions
HOME_LINKS=(
    "$HOME/.zshrc"
    "$HOME/.config/alacritty/alacritty.toml"
    "$HOME/.config/fastfetch/config.jsonc"
)

REPO_LINKS=(
    "$REPO/.zshrc"
    "$REPO/.config/alacritty/alacritty.toml"
    "$REPO/.config/fastfetch/config.jsonc"
)

STATUS_REPORT=()

echo " Checking symbolic links..."

for i in "${!HOME_LINKS[@]}"; do
    LINK="${HOME_LINKS[$i]}"
    TARGET="${REPO_LINKS[$i]}"
    SHORT_LINK="${LINK/#$HOME/~}"

    if [ "$(readlink -f "$LINK" 2>/dev/null)" = "$(realpath "$TARGET")" ]; then
        STATUS_REPORT+=("󰄬 OK        → $SHORT_LINK")
    else
        mkdir -p "$(dirname "$LINK")"
        ln -sf "$TARGET" "$LINK"
        STATUS_REPORT+=("󰅖 Fixed     → $SHORT_LINK")
    fi
done


echo -e "\n󰊢 Syncing Git repository..."

cd "$REPO" || { echo "󰅙 Failed to access $REPO"; exit 1; }

# Auto-stash before rebase
git stash push -m "auto-stash before rebase" >/dev/null 2>&1 || true
git pull --rebase origin main || true
git stash pop >/dev/null 2>&1 || true

# Commit and push changes
git add .
if git commit -m "Auto-update $(date +%F_%T)" >/dev/null 2>&1; then
    git push origin main
else
    STATUS_REPORT+=("󰝦 No changes to commit")
fi

# Final report
echo -e "\n Final Report:"
for line in "${STATUS_REPORT[@]}"; do
    echo "$line"
done

echo -e "\n Done."
