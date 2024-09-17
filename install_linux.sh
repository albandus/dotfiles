#!/usr/bin/env bash

set -eu

hash stow 2> /dev/null || { echo >&2 "stow not installed"; exit 1; }

mkdir -p ~/.config
mkdir -p ~/.$USER/bin
mkdir -p ~/.$USER/XDG_PublicShare_Dir
stow -v -d home -t ~ .
stow -v -d config -t ~/.config .
stow -v -d bin -t ~/.$USER/bin .
if [ ! -e ~/.local_tmux.conf ]
then
    echo "# Set status bar color, to list colour codes, run ~/.config/tmux/tmux-list-color-codes.sh" > ~/.local_tmux.conf
    echo "set -g status-bg colour$((1 + $RANDOM % 254))" >> ~/.local_tmux.conf
fi
if [ ! -e ~/.config/tmux/plugins/tpm ]
then
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi
if [ ! -e ~/.local_gitconfig ]
then
    echo "[user]" > ~/.local_gitconfig
    echo "    ;name = Alban" >> ~/.local_gitconfig
    echo "    ;email = albandus@users.noreply.github.com" >> ~/.local_gitconfig
fi
if [ ! -e ~/.gnupg/gpg-agent.conf ]
then
    mkdir -p ~/.gnupg
    chmod 700 ~/.gnupg
    cp ./gpg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
fi
