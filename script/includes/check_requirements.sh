#!/usr/bin/env bash

check_requirements () {
    error=0
    git=$(type git > /dev/null; echo $?)
    if [[ $git == 1 ]]
    then
        error=1
        errorMsg "git not installed"
    fi

    if [[ $error == 1 ]]
    then
        exit 1
    fi
}
