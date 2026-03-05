# If we are not inside the tmux run it
[[ $TERM =~ ^tmux ]] || tmux

# Options
setopt NO_BEEP
setopt AUTO_CD
setopt CORRECT
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY 
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Key bindings
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Core utils aliases
alias ls="ls -a --color=always --group-directories-first"
alias du="du -h"
alias df="df -h"
alias free="free -h"

# History config
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=$HISTSIZE

# Gloabal aliases
alias -g NE="2>/dev/null"
alias -g NO="1>/dev/null"
alias -g N="1>/dev/null 2>&1"
alias -g CP="| xclip -selection clipboard" 
alias -g L="| less"

# Some variables
export DISTRO=$(cat /etc/os-release | awk -F "=" '/^NAME=/ {print $2}' | tr -d '"')
export ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"

# $PATH
export PATH="$PATH:$HOME/.local/bin"

# chpwd hook
chpwd() {
	if [[ -d .git ]]; then
		git status -s
		echo ""
	fi

	ls
}

# Create history file
[ -f $HISTFILE ] || touch $HISTFILE

# Source zinit
source $ZINIT_HOME/zinit.zsh

# Enable zinit plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Apply ohmyposh config
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/ohmyposh.toml)"

# Print distro logo
fastfetch
