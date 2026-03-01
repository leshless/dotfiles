#!/bin/bash
set -e

RED='\033[1;31m'
CYAN='\033[1;96m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

APT_PACKAGES="git stow curl tree wget tmux unzip neofetch gnome-tweaks"
SNAP_PACKAGES="obsidian"
DOTFILES_REPO_URL="https://github.com/leshless/dotfiles.git"

print_default() {
    echo -e "[$(date "+%d %b %Y %H:%M:%S")] ${CYAN}$1${NC}"
}

print_success() {
    echo -e "[$(date "+%d %b %Y %H:%M:%S")] ${GREEN}$1${NC}"
}

print_warning() {
    echo -e "[$(date "+%d %b %Y %H:%M:%S")] ${YELLOW}$1${NC}"
}

print_error() {
    echo -e "[$(date "+%d %b %Y %H:%M:%S")] ${RED}$1${NC}"
}

print_default "🔥 Setting up desktop!"

source /etc/os-release

HOST_OS=$ID

if [[ $HOST_OS == ubuntu ]]; then	
	# Update APT
	print_default "Updating APT..."

	sudo apt update 1>/dev/null

	# Install APT stuff
	print_default "Installing APT packages..."

	sudo apt install -y $APT_PACKAGES 1>/dev/null

	# Install Snap stuff (apps) 
	print_default "Installing Snap packages..."

	snap install $SNAP_PACKAGES --classic 1>/dev/null
fi

# Generate SSH key
print_default "Generating SSH key..."

ssh-keygen -t ed25519 -N "" -q -f ~/.ssh/id_ed25519

print_default "Generated public SSH key:$NC $(cat ~/.ssh/id_ed25519.pub)"

# Clone dotfiles repo
print_default "Clonning dotfiles repo..."

git clone $DOTFILES_REPO_URL 1>/dev/null

# Stow dotfiles (return back to user)
print_default "Loading configs..."

rm ~/.bashrc ~/.bash_logout ~/.profile
cd dotfiles && stow . 1>/dev/null

print_success "🔥 Setup done!"

