#!/usr/bin/env bash

setup_bashrc () {
    local WORKING_DIR="$1" dst="$2"

    # Build target file as tmp
    tmpFile=$(mktemp $TMPDIR/bashrc.symlink.XXXXX)
    chmod 664 $tmpFile
    sed -e "s@BOOTSTRAP_DOTFILES_ROOT@$WORKING_DIR@g" $WORKING_DIR/bash/bashrc.symlink.template > $tmpFile

    if [ ! -f $dst ]
    then
        mv $tmpFile $dst
        successMsg "setup bashrc.symlink"
        return
    fi

    # If target file exists, checks diff to show status
    diffStatus=$(diff -q $dst $tmpFile > /dev/null; echo $?)
    if [ $diffStatus -eq 0 ]
    then
        rm -f $tmpFile
        infoMsg "$dst already OK"
        return
    fi

    # || true, avoid script ending with diff exit code
    diff $tmpFile $dst || true
    local action=
    askMsg "File already exists: $dst\n\
    and is different from generated one $tmpFile, what do you want to do?\n\
    [s]kip,  [o]verwrite, [b]ackup?"
    read -n 1 action

    case "$action" in
      b )
        backup=$(date "+%Y-%m-%d")
        backup=$(mktemp "$dst.backup.$backup.XXX")
        mv $dst "$backup"
        ;;
      o )
        ;;
      s )
        return;;
      * )
        return;;
    esac
    mv $tmpFile $dst
    successMsg "$dst built"
}
