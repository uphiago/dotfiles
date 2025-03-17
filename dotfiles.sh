#!/usr/bin/env bash

REPO="$HOME/Repositories/devops/dotfiles"
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

echo "🔍 Verificando links simbólicos..."

for i in "${!HOME_LINKS[@]}"; do
    LINK="${HOME_LINKS[$i]}"
    TARGET="${REPO_LINKS[$i]}"
    
    if [ "$(readlink -f "$LINK" 2>/dev/null)" = "$(realpath "$TARGET")" ]; then
        STATUS_REPORT+=("🟢 OK: ${LINK/#$HOME/~}")
    else
        mkdir -p "$(dirname "$LINK")"
        ln -sf "$TARGET" "$LINK"
        STATUS_REPORT+=("🔁 Corrigido: ${LINK/#$HOME/~}")
    fi
done

echo -e "\n📦 Git sync..."

cd "$REPO" || { echo "❌ Falha ao acessar $REPO"; exit 1; }

git pull --rebase origin main
git add .
git commit -m "Auto-update $(date +%F_%T)" >/dev/null 2>&1 || STATUS_REPORT+=("⚠️ Nada para commit")
git push origin main

echo -e "\n📄 Relatório final:"
for line in "${STATUS_REPORT[@]}"; do
    echo "$line"
done

echo -e "\n✅ Finalizado."
