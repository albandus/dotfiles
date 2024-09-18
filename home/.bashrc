# If not running interactively, don't do anything
[ -z "$PS1" ] && return

[ -f ~/.local_bashrc ] && source ~/.local_bashrc

export EDITOR=nvim
export LC_ALL=en_US.UTF-8
export QUOTING_STYLE=literal
export HISTCONTROL=ignoreboth
export HISTSIZE='32768';
export HISTFILESIZE="${HISTSIZE}";

# append to the history file, don't overwrite it
shopt -s histappend

if [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
    fi
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# enable color in some command output
if [ -x /usr/bin/dircolors ]; then
    eval `dircolors`
fi
if [ "$(uname -s)" == "Darwin" ]
then
    export CLICOLOR="xterm"
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias l='ls -l'
alias la="ls -la"
alias lh='ls -lh'
# ripgrep: disable very long lines
alias rg='rg -M 500'

alias c='grep -rnIi --color=always'
# grep | less
gl () {
    grep -rnIi $@ --color=always | less -R
}

alias cls="clear && tmux clear-history"
alias hx="helix"
alias n="nvim"
alias ysearch="yay -Slq | fzf --no-mouse --preview 'yay -Si {}' --layout=reverse"
alias yinstalled="yay -Qq | fzf --no-mouse --preview 'yay -Qil {}' --layout=reverse --bind 'enter:execute(yay -Qil {} | less)'"
alias d="diff-so-fancy | less -R"
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

#######################################
### Prompt

promptUser="$(whoami)"
if [[ "${promptUser}" == "${HIDE_USER_IN_PROMPT:-alban}" ]]
then
    promptUser=""
fi
promptHostname="$(hostname)"
if [[ "${promptHostname}" == "${HIDE_HOSTNAME_IN_PROMPT}" ]]
then
    promptHostname=""
fi

_dir_chomp () {
    # First argument: path

    # p: path replacing $HOME in path by ~
    # b/s: ensure local variables
    local p=${1/#$HOME/\~} b s
    # s: length of path
    s=${#p}
    # while path still contain a "/", and length over max 
    # ${p//\/} == replace all occurences of / in path
    while [[ $p != "${p//\/}" ]]&&(($s>20))
    do
        p=${p#/} # remove "/" as prefix
        [[ $p =~ \.?[^/]{1,2} ]] # regexp: match eventual dot and 2 first chars
        b=$b/${BASH_REMATCH[0]}
        p=${p#*/} # remove processed dir
        ((s=${#b}+${#p})) # update length
    done
    # $b: chomped and $p last dir or remaining path if shorter than max length
    # ${b/\/~/\~}: remove "/" prefix in front of "~"
    # ${b+/}: do not add a "/" if b is empty
    echo ${b/\/~/\~}${b+/}$p
}
PS1="\[\e[0;36m\]\$(date +%H:%M) \[\e[0;33m\]${promptUser}\[\e[0;32m\]@\[\e[0;32m\]${promptHostname} \[\e[1;34m\]\$(_dir_chomp \"\$(pwd)\") \[\e[1;34m\]%\[\e[0;m\] "


#######################################
### Git shortcuts

g() { if [[ $# > 0 ]]; then git "$@"; else git status; fi; }
# Enable git bash completion on g function
if [ -r /usr/share/bash-completion/completions/git ]
then
    source /usr/share/bash-completion/completions/git
    __git_complete g __git_main
fi
alias gsl="git stash list"
gss() { if [[ $# = 1 ]]; then git stash save "$1"; else echo "Stash name required."; fi; }
gsa() { git stash apply stash@{$1}; }
gsd() { git stash drop stash@{$1}; }

#######################################
### Bash completion
# mac-os only, no need on linux
# Require brew install bash_completion@2

if [ -r /opt/homebrew/etc/profile.d/bash_completion.sh ]
then
    source /opt/homebrew/etc/profile.d/bash_completion.sh
    __git_complete g __git_main
fi

#######################################

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.$USER/dotfiles}"
# Tests to avoid unwanted errors on uncommon config (for example, an aws
# instance, with "ubuntu" user)
if [ -d "$DOTFILES_DIR" ]
then
    hasDiff=$(git -C $DOTFILES_DIR status --porcelain | wc -l)
    if [ $hasDiff -ne 0 ]
    then
        echo "Dotfiles repository has uncommitted changes"
    fi
fi

#######################################

# Custom script/bin folder
PATH="$PATH:$HOME/.$USER/bin"

export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Used by: poetry, getnf
export PATH="$HOME/.local/bin:$PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#######################################

if [[ ! $TERM =~ screen ]]; then
    [[ -n "$(type -p tmux)" ]] && tmux
fi

