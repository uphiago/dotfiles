#!/bin/bash

REPO_PATH="$HOME/Repositories/personal/configs/dotfiles"

cd $REPO_PATH

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

git add .
git commit -m "Auto-commit: Config files updated. $TIMESTAMP"
git push origin main
