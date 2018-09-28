#!/usr/bin/env bash

# Copy/paste from includes/setup_bashrc.sh, code should be mutualised.

setup_gitconfig () {
    local WORKING_DIR="$1" dst="$2"

    # Build target file as tmp
    tmpFile=$(mktemp $TMPDIR/gitconfig.symlink.XXXXX)
    chmod 664 $tmpFile
    sed -e "s@BOOTSTRAP_DOTFILES_ROOT@$WORKING_DIR@g" $WORKING_DIR/git/gitconfig.symlink.template > $tmpFile
    askMsg "Git username? "
    read gitUsername
    askMsg "Git email? "
    read gitEmail
    sed -e "s@BOOTSTRAP_GIT_USERNAME@$gitUsername@g" -i "" $tmpFile
    sed -e "s/BOOTSTRAP_GIT_EMAIL/$gitEmail/g" -i "" $tmpFile

    if [ ! -f $dst ]
    then
        mv $tmpFile $dst
        successMsg "setup gitconfig.symlink"
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
