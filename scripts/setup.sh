#!/bin/bash
set -e

RED='\033[1;31m'
CYAN='\033[1;96m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

APT_PACKAGES="git vim stow zsh tmux curl tree wget unzip neofetch gnome-tweaks"
SNAP_PACKAGES="obsidian"
DOTFILES_REPO_URL="https://github.com/leshless/dotfiles.git"

info() {
    echo -e "[$(date "+%d %b %Y %H:%M:%S")] ${CYAN}$1${NC}"
}

success() {
    echo -e "[$(date "+%d %b %Y %H:%M:%S")] ${GREEN}$1${NC}"
}

warn() {
    echo -e "[$(date "+%d %b %Y %H:%M:%S")] ${YELLOW}$1${NC}"
}

error() {
    echo -e "[$(date "+%d %b %Y %H:%M:%S")] ${RED}$1${NC}"
}

info "💻 Setting up desktop!"

DISTRO=$(cat /etc/os-release | awk -F "=" '/^NAME=/ {print $2}' | tr -d '"')

apt_packages=(
	git
	tmux
	vim
	stow
	zsh
	curl
	tree
	unzip
	neofetch
)
snap_packages=(
	obsidian
)

if [[ $DISTRO == Ubuntu ]]; then	
	# Update APT
	info "Updating APT..."

	sudo apt update 1>/dev/null

	# Install APT stuff
	info "Installing APT packages..."

	sudo apt install -y ${apt_packages[@]} 1>/dev/null

	# Install Snap stuff (apps) 
	info "Installing Snap packages..."

	sudo snap install ${snap_packages[@]} --classic 1>/dev/null
fi

# Generate SSH key
info "Generating SSH key..."

ssh-keygen -t ed25519 -N "" -q -f ~/.ssh/id_ed25519

info "Generated public SSH key:$NC $(cat ~/.ssh/id_ed25519.pub)"

# Clone dotfiles repo
info "Clonning dotfiles repo..."

git clone $DOTFILES_REPO_URL 1>/dev/null

# Stow dotfiles (return back to user)
info "Loading configs..."

rm ~/.bashrc ~/.bash_logout ~/.profile
cd dotfiles && stow . 1>/dev/null

success "💻 Setup done!"

