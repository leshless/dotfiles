#!/bin/bash
set -e

BOLD='\033[1m'
RED='\033[31m'
CYAN='\033[96m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
NC='\033[0m'

EXCLUDE_FILES=(
    .zshrc
    .zcompdump
    .zsh_history
    .tmux.conf
    .bashrc 
    .bash_profile
    .bash_login
    .bash_history
    .bash_logout
    .profile
    .gitconfig
    .viminfo
    .sudo_as_admin_successful
)
EXCLUDE_DIRS=(
    .local
    .cache
    .config
    .docker
    .dotnet
    .gnupg
    .go
    .java
    .npm
    .pki
    .snap
    .ssh
    .vscode
    .vim
    snap
)

files=()
dirs=()
links=()
empty=1

shopt -s dotglob
for entry in $HOME/*; do
    if [[ -f $entry ]]; then
        f=1
        for file in ${EXCLUDE_FILES[@]}; do
            if [[ $(basename $entry) == $file ]]; then
                f=0
                break
            fi
        done

        if [[ $f == 1 ]]; then
            files+=("$entry")
            empty=0
        fi
    fi

    if [[ -d $entry ]]; then
        f=1
        for dir in ${EXCLUDE_DIRS[@]}; do
            if [[ $(basename $entry) == $dir ]]; then
                f=0
                break
            fi
        done

        if [[ -d $entry/.git ]]; then
            f=0
        fi

        if [[ $f == 1 ]]; then
            dirs+=("$entry")
            empty=0
        fi
    fi

    if [[ -L $entry ]]; then
        f=1
        for file in ${EXCLUDE_FILES[@]}; do
            if [[ $(basename $entry) == $file ]]; then
                f=0
                break
            fi
        done
        for dir in ${EXCLUDE_DIRS[@]}; do
            if [[ $(basename $entry) == $dir ]]; then
                f=0
                break
            fi
        done

        if [[ $f == 1 ]]; then
            links+=("$entry")
            empty=0
        fi
    fi
done

if [[ $empty == 1 ]]; then
    echo -e "${BOLD}Nothing to cleanup${NC}"
    exit 0
fi

echo -e "${BOLD}The following stuff will be removed permanently:${NC}"
echo -e "${BLUE}${dirs[@]} ${NC}${files[@]} ${CYAN}${links[@]}${NC}"

echo -en "${BOLD}Continue? [y/n]${NC}"
read -p " " yn
case $yn in
    [Yy]* ) 
        for i in ${!dirs[@]}; do
            rm -rf "${dirs[i]}"
        done
        for i in ${!files[@]}; do
            rm -rf "${files[i]}"
        done
        for i in ${!links[@]}; do
            rm -rf "${links[i]}"
        done;;
    * ) exit;;
esac    
