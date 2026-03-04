# Options
setopt NO_BEEP
setopt AUTO_CD
setopt CORRECT

# Core utils aliases
alias ls="ls -a --color=always --group-directories-first"
alias du="du -h"
alias df="df -h"
alias free="free -h"

# History config
HISTFILE="~/.history"
HISTSIZE=100
SAVEHIST=100

# Gloabal aliases
alias -g NE="2>/dev/null"
alias -g NO="1>/dev/null"
alias -g N="1>/dev/null 2>&1"
alias -g CP="| xclip -selection clipboard" 
alias -g L="| less"

# Some variables
export DISTRO=$(cat /etc/os-release | awk -F "=" '/^NAME=/ {print $2}' | tr -d '"')

# chpwd hook
chpwd() {
	if [[ -d .git ]]; then
		git status -s
		echo ""
	fi

	ls
}

# If we are not in tmux launch it
if [[ $TERM =~ ^tmux ]]; then
	neofetch
else
	tmux
fi
