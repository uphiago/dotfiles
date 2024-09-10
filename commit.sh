#!/bin/bash

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
git config --global --add safe.directory /home/volks/Repositories/personal/configs/dotfiles

REPO_PATH="/home/volks/Repositories/personal/configs/dotfiles"

cd $REPO_PATH

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

git add .
git commit -m "Auto-commit: Config files updated. $TIMESTAMP"
git push origin main
