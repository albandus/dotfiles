#!/usr/bin/env bash

# Original copied from https://github.com/holman/dotfiles/blob/master/script/bootstrap

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

# Auto-exit on errors
set -e

source ${DOTFILES_ROOT}/script/includes/messages.sh
source ${DOTFILES_ROOT}/script/includes/link_file.sh
source ${DOTFILES_ROOT}/script/includes/install_dotfiles.sh
source ${DOTFILES_ROOT}/script/includes/setup_bashrc.sh

setup_bashrc
install_dotfiles
successMsg 'All installed!'
