#!/bin/bash

git config --global --add safe.directory /home/volks/Repositories/personal/configs/dotfiles

REPO_PATH="/home/volks/Repositories/personal/configs/dotfiles"

cd $REPO_PATH || { echo "Error $REPO_PATH"; exit 1; }

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

git add .
git commit -m "Auto-commit: Config updated $TIMESTAMP"
git push origin main
