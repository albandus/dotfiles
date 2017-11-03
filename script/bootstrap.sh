#!/usr/bin/env bash

# Copied from https://github.com/holman/dotfiles/blob/master/script/bootstrap

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

# Auto-exit on errors
set -e

infoMsg () {
    printf "\r[\033[00;34mINFO\033[0m] $1\n"
}

askMsg () {
    printf "\r[\033[0;33m????\033[0m] $1\n"
}

successMsg () {
    printf "\r\033[2K[\033[00;32mOK  \033[0m] $1\n"
}

warnMsg () {
    printf "\r[\033[0;33mWARN\033[0m] $1\n"
}

errMsg () {
    printf "\r[\033[0;31mERR \033[0m] $1\n"
}

fatalMsg () {
    errMsg "$1"
    exit 1
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        askMsg "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      successMsg "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      backup=$(date "+%Y-%m-%d")
      backup=$(mktemp "$dst.backup.$backup.XXX")
      mv "$dst" "$backup"
      successMsg "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      successMsg "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    successMsg "linked $1 to $2"
  fi
}

install_dotfiles () {
  infoMsg 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

setup_bashrc () {
    # Build target file as tmp
    tmpFile=$(mktemp $DOTFILES_ROOT/bash/bashrc.XXX)
    chmod 664 $tmpFile
    sed -e "s@BOOTSTRAP_DOTFILES_ROOT@$DOTFILES_ROOT@g" bash/bashrc.symlink.template > $tmpFile

    if [ ! -f bash/bashrc.symlink ]
    then
        mv $tmpFile bash/bashrc.symlink
        successMsg "setup bashrc.symlink"
        return
    fi

    # If target file exists, checks diff to show status
    diffStatus=$(diff -q bash/bashrc.symlink $tmpFile > /dev/null; echo $?)
    if [ $diffStatus -eq 0 ]
    then
        rm -f $tmpFile
        infoMsg "bash/bashrc.symlink already OK"
        return
    fi

    local action=
    askMsg "File already exists: $DOTFILES_ROOT/bash/bashrc.symlink, what do you want to do?\n\
    [s]kip,  [o]verwrite, [b]ackup?"
    read -n 1 action

    case "$action" in
      b )
        backup=$(date "+%Y-%m-%d")
        backup=$(mktemp "bashrc.symlink.backup.$backup.XXX")
        mv "bash/bashrc.symlink" "bash/$backup"
        ;;
      o )
        ;;
      s )
        return;;
      * )
        return;;
    esac
    mv $tmpFile bash/bashrc.symlink
    successMsg 'bash/bashrc.symlink built'
}

setup_bashrc
install_dotfiles
successMsg 'All installed!'

