#!/usr/bin/env bash

vundle_setup () {
    if [ -d "$HOME/.vim/bundle/Vundle.vim" ]
    then
        infoMsg "Vundle setup already done"
        return
    fi
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    successMsg "Vundle setup OK"
}
