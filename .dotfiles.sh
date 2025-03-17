#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
DOTFILE_LINK="$HOME/.dotfiles.sh"

if [ ! -L "$DOTFILE_LINK" ] || [ "$(readlink -f "$DOTFILE_LINK")" != "$REPO/.dotfiles.sh" ]; then
    echo "󰅖 Creating symlink: $DOTFILE_LINK → $REPO/.dotfiles.sh"
    ln -sf "$REPO/.dotfiles.sh" "$DOTFILE_LINK"
fi

STATUS_REPORT=()

echo " Scanning and linking dotfiles from: $REPO"

while IFS= read -r -d '' FILE; do
    REL_PATH="${FILE#$REPO/}"
    TARGET="$FILE"
    LINK="$HOME/$REL_PATH"
    SHORT_LINK="${LINK/#$HOME/~}"

    if [ "$(readlink -f "$LINK" 2>/dev/null)" = "$(realpath "$TARGET")" ]; then
        STATUS_REPORT+=("󰄬 OK        → $SHORT_LINK")
    else
        mkdir -p "$(dirname "$LINK")"
        ln -sf "$TARGET" "$LINK"
        STATUS_REPORT+=("󰅖 Linked    → $SHORT_LINK")
    fi
done < <(find "$REPO" -type d -name .git -prune -o -type f -print0)

echo -e "\n󰊢 Syncing Git repository..."

cd "$REPO" || { echo "󰅙 Failed to access $REPO"; exit 1; }

git stash push -m "auto-stash before rebase" >/dev/null 2>&1 || true
git pull --rebase origin main || true
git stash pop >/dev/null 2>&1 || true

git add .
if git commit -m "Auto-update $(date +%F_%T)" >/dev/null 2>&1; then
    git push origin main
else
    STATUS_REPORT+=("󰝦 No changes to commit")
fi

echo -e "\n Final Reports:"
for line in "${STATUS_REPORT[@]}"; do
    echo "$line"
done

echo -e "\n Done."
