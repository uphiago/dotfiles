#!/bin/bash

# Verifica se o ssh-agent já está em execução
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

# Adiciona a chave SSH, se necessário
ssh-add -l | grep ~/.ssh/id_ed25519 > /dev/null || ssh-add ~/.ssh/id_ed25519

# Adiciona o diretório como seguro para o Git
git config --global --add safe.directory /home/volks/Repositories/personal/configs/dotfiles

# Caminho para o diretório do repositório
REPO_PATH="/home/volks/Repositories/personal/configs/dotfiles"

# Mude para o diretório do repositório
cd $REPO_PATH || { echo "Erro ao mudar para o diretório $REPO_PATH"; exit 1; }

# Obter o timestamp atual
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Adicionar e comitar alterações com timestamp na mensagem de commit
git add .
git commit -m "Auto-commit: Atualização de arquivos de configuração em $TIMESTAMP"
git push origin main  # ou "master", se for o seu branch principal
