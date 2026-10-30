#!/bin/bash

input=$(cat)



# Extrai os dados

MODEL=$(echo "$input" | jq -r '.model.display_name // "model"')

DIR=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')

PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')



# Pega só o nome da pasta

FOLDER="${DIR##*/}"



# Branch do git (se existir)

BRANCH=""

if git -C "$DIR" rev-parse --git-dir >/dev/null 2>&1; then

  BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)

fi



# Barra de contexto (10 caracteres)

BAR_WIDTH=10

FILLED=$((PCT * BAR_WIDTH / 100))

EMPTY=$((BAR_WIDTH - FILLED))



BAR=""

[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /█}"

[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"



# Formata o custo (com vírgula no lugar do ponto)

COST_FMT=$(printf '%.2f' "$COST" | sed 's/\./,/')



# Monta a linha

echo -n "[$MODEL] 📁 $FOLDER"

[ -n "$BRANCH" ] && echo -n " | 🌿 $BRANCH"

echo -n " | 🧠 $BAR ${PCT}% | 💰 \$$COST_FMT"



# Se quiser adicionar algo extra (ex: Remote Control), descomente e adapte

# echo -n " Remote Control active"
