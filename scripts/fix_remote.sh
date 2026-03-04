#!/bin/bash

DOTFILES_REPO_URL="git@github.com:leshless/dotfiles.git"

cd ~/dotfiles

git remote remove origin
git remote add origin $DOTFILES_REPO_URL
