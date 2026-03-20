#!/bin/bash
# set -e

RED='\033[1;31m'
CYAN='\033[1;96m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'

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
	alacritty
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

	for snap_package in "${snap_packages[@]}"; do 
		sudo snap install $snap_package 1>/dev/null
	done

	# Install fastfetch
	info "Installing fastfetch..."
	wget -q https://github.com/fastfetch-cli/fastfetch/releases/download/2.59.0/fastfetch-linux-amd64.deb 1>/dev/null
	sudo apt install ./fastfetch-linux-amd64.deb 1>/dev/null
	rm -rf ./fastfetch-linux-amd64.deb
	
fi

# Generate SSH key
info "Generating SSH key..."

ssh-keygen -t ed25519 -N "" -q -f ~/.ssh/id_ed25519

info "Generated public SSH key:$NC $(cat ~/.ssh/id_ed25519.pub)"

# Clone dotfiles repo
info "Clonning dotfiles repo..."

DOTFILES_REPO_URL="https://github.com/leshless/dotfiles.git"
git clone $DOTFILES_REPO_URL 1>/dev/null

# Download zinit (zsh plugin manager)
info "Installing zinit..."

ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# Download ohmyposh (zsh prompt customization)
curl -s https://ohmyposh.dev/install.sh | bash -s 1>/dev/null

# Stow dotfiles
info "Loading configs..."

rm ~/.bashrc ~/.bash_logout ~/.profile ~/.config/user-dirs.dirs
cd dotfiles && stow . 1>/dev/null

user_dirs=(
	$HOME/Desktop
	$HOME/Documents
	$HOME/Music
	$HOME/Pictures
	$HOME/Templates
	$HOME/Downloads
	$HOME/Videos
	$HOME/Public
)
# On ubuntu, remove title dirs
if [[ $DISTRO == Ubuntu ]]; then
	info "Removing redundant dirs..."

	user_dirs=(
        $HOME/Desktop
        	HOME/Documents
        	HOME/Music
        	HOME/Pictures
        	HOME/Templates
        	HOME/Downloads
        	HOME/Videos
        	HOME/Public
	)
	
	rm -rf ${user_dirs[@]} 
fi 

success "💻 Setup done!"
