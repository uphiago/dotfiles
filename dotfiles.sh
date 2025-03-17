#!/usr/bin/env bash
set -euo pipefail

REPO="$HOME/Repositories/devops/dotfiles"
STATUS_REPORT=()

echo " Scanning and linking dotfiles from: $REPO"

while IFS= read -r -d '' FILE; do
    REL_PATH="${FILE#$REPO/}"                 # strip repo base path
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
done < <(find "$REPO" -type f -print0)

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

echo -e "\n Final Report:"
for line in "${STATUS_REPORT[@]}"; do
    echo "$line"
done

echo -e "\n Done."
