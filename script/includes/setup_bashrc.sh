#!/usr/bin/env bash

setup_bashrc () {
    # Build target file as tmp
    tmpFile=$(mktemp $DOTFILES_ROOT/bash/bashrc.symlink.XXX)
    chmod 664 $tmpFile
    sed -e "s@BOOTSTRAP_DOTFILES_ROOT@$DOTFILES_ROOT@g" $DOTFILES_ROOT/bash/bashrc.symlink.template > $tmpFile

    if [ ! -f $DOTFILES_ROOT/bash/bashrc.symlink ]
    then
        mv $tmpFile $DOTFILES_ROOT/bash/bashrc.symlink
        successMsg "setup bashrc.symlink"
        return
    fi

    # If target file exists, checks diff to show status
    diffStatus=$(diff -q $DOTFILES_ROOT/bash/bashrc.symlink $tmpFile > /dev/null; echo $?)
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
        backup=$(mktemp "$DOTFILES_ROOT/bashrc.symlink.backup.$backup.XXX")
        mv "$DOTFILES_ROOT/bash/bashrc.symlink" "$backup"
        ;;
      o )
        ;;
      s )
        return;;
      * )
        return;;
    esac
    mv $tmpFile $DOTFILES_ROOT/bash/bashrc.symlink
    successMsg 'bash/bashrc.symlink built'
}
