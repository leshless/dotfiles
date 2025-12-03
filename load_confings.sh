#!/bin/bash

# Envs
DESK_REPO_PATH="$HOME/desk"
DESK_SCRIPTS_PATH="$DESK_REPO_PATH/scripts"
DESK_CONFIGS_PATH="$DESK_REPO_PATH/configs"

set -e

# Home .config folder for all configs
HOME_CONFIG_PATH=$HOME/.config
mkdir -p $HOME_CONFIG_PATH

# tmux
mkdir -p $HOME_CONFIG_PATH/tmux
cp $DESK_CONFIGS_PATH/tmux.conf $HOME_CONFIG_PATH/tmux/tmux.conf
echo "Loaded tmux config"

echo "All configs sucessfuly loaded"