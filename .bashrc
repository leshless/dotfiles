# This is what I basically want to launch in every terminal

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Handy aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias du='du -h'
alias df='df -h'
alias free='free -h'

# PS1 Prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Go environment
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOPATH

# Scripts directory
export SCRIPTS_PATH=$HOME/scripts

# Aliases for scripts
alias cleanup="$SCRIPTS_PATH/cleanup.py"

# If we are not in tmux, run tmux
# Instead, just print beatiful logo
if [[ "$TERM" =~ ^xterm ]]; then
    tmux
else
    fastfetch
fi

