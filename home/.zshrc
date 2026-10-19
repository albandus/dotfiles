# If not running interactively, don't do anything
[[ -o interactive || -n "$CLAUDECODE" ]] || return

__add_path_entry() {
    case ":$PATH:" in
      *":$1:"*) :;; # already there
      *) PATH="$1:$PATH";; # or PATH="$PATH:$new_entry"
    esac
}

CUSTOM_BIN="$HOME/.$USER/bin"
[ -f ~/.local_zshrc ] && source ~/.local_zshrc

export EDITOR=nvim
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export QUOTING_STYLE=literal

#######################################
### Zsh options

# Emacs keybindings, else zsh picks vi mode because EDITOR contains "vi"
bindkey -e
# Allow comments in interactive shell, like bash
setopt interactive_comments
setopt prompt_subst

HISTFILE=~/.zsh_history
HISTSIZE=32768
SAVEHIST=$HISTSIZE
setopt inc_append_history hist_ignore_space hist_ignore_dups extended_history

# Keys not bound by default (xterm/alacritty and tmux sequences)
bindkey '^[[H' beginning-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OF' end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
# Ctrl-W / word moves stop at path separators
WORDCHARS=${WORDCHARS//\/}

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#######################################

if [[ "$OSTYPE" == "darwin"* ]]; then
    sshAgentFile="$HOME/.ssh/ssh-agent.env"
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent -t 40h > "$sshAgentFile"
    fi
    source "$sshAgentFile" > /dev/null
elif [[ ! -S "$SSH_AUTH_SOCK" ]]; then
    if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
    fi
    source "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null
fi

# enable color in some command output
if [ -x /usr/bin/dircolors ]; then
    eval `dircolors`
fi
if [[ "$(uname -s)" == "Darwin" ]]
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

docker-rmi-all-force() {
    docker stop $(docker ps -q)
    docker rm $(docker ps -a -q)
    docker rmi $(docker images -q) --force
}

alias c='grep -rnIi --color=always'
# grep | less
gl () {
    grep -rnIi "$@" --color=always | less -R
}

alias cls="clear && tmux clear-history"
alias n="nvim"
alias ysearch="yay -Slq | fzf --no-mouse --preview 'yay -Si {}' --layout=reverse"
alias yinstalled="yay -Qq | fzf --no-mouse --preview 'yay -Qil {}' --layout=reverse --bind 'enter:execute(yay -Qil {} | less)'"
alias d="diff-so-fancy | less -R"
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'

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

# Same as bash version, see .bashrc for details. Differences: zsh stores regexp
# match in $MATCH, and "local b" defines b as empty, hence ${b:+/}
_dir_chomp () {
    local p=${1/#$HOME/\~} b s
    s=${#p}
    while [[ $p != "${p//\/}" ]] && (( s > 20 ))
    do
        p=${p#/}
        [[ $p =~ '\.?[^/]{1,2}' ]]
        b=$b/$MATCH
        p=${p#*/}
        (( s = ${#b} + ${#p} ))
    done
    echo ${b/\/~/\~}${b:+/}$p
}
PS1='%F{cyan}%D{%H:%M} %F{yellow}${promptUser}%F{green}@${promptHostname} %B%F{blue}$(_dir_chomp "$PWD") %%%f%b '

#######################################
### Git shortcuts

g() { if (( $# > 0 )); then git "$@"; else git status; fi; }
compdef g=git
alias gsl="git stash list"
gss() { if [[ $# = 1 ]]; then git stash save "$1"; else echo "Stash name required."; fi; }
gsa() { git stash apply stash@{$1}; }
gsd() { git stash drop stash@{$1}; }

alias ga="git add -A"
gc() {
    git commit -m "$*"
}

#######################################

if command -v fzf >/dev/null
then
    source <(fzf --zsh)
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
__add_path_entry "$CUSTOM_BIN"

export GOPATH="$HOME/.go"
__add_path_entry "$GOPATH/bin"

__add_path_entry "$HOME/.local/bin"

if type pyenv >/dev/null 2>&1
then
    eval "$(pyenv init -)"
fi

if type rbenv >/dev/null 2>&1
then
    # rbenv, require check, not able to properly manage if it is already there
    # Check: if ~/.rbenv/shims already in path
    case ":$PATH:" in
      *":$HOME/.rbenv/shims:"*) :;; # already there
      *) eval "$(rbenv init - --no-rehash zsh)"
    esac
fi

#######################################
# Auto-launch tmux, set shortcuts to swtich colors

if command -v tmux>/dev/null && [[ "$TERM_PROGRAM" != "vscode" ]] ; then
    [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && tmux new-session -A -s main

    # check if we have been switched to light, else go dark
    [[ ! $(tmux show-environment | grep THEME) =~ 'THEME=light' ]] &&
    tmux set-environment THEME dark
fi
alias tmain="tmux new-session -A -s main"
alias jour="tmux source-file $DOTFILES_DIR/config/tmux/tmux_light.conf; tmux set-environment THEME 'light'"
alias nuit="tmux source-file $DOTFILES_DIR/config/tmux/tmux_dark.conf; tmux set-environment THEME 'dark'"

# pnpm
export PNPM_HOME="/Users/alban/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if command -v mise >/dev/null
then
    eval "$(mise activate zsh)"
fi

#######################################
# Plugins, syntax highlighting must be sourced last

for plugin in zsh-autosuggestions zsh-syntax-highlighting
do
    for dir in /usr/share/zsh/plugins /opt/homebrew/share
    do
        if [ -r "$dir/$plugin/$plugin.zsh" ]
        then
            source "$dir/$plugin/$plugin.zsh"
            break
        fi
    done
done
unset plugin dir
