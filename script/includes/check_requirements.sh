#!/usr/bin/env bash

check_requirements () {
    local error=0
    if [[ $(type git > /dev/null 2>&1; echo $?) == 1 ]]
    then
        error=1
        errMsg "git not installed"
    fi

    if [ "$(uname -s)" == "Darwin" ]
    then
        if [[ $(type brew > /dev/null 2>&1; echo $?) == 1 ]]
        then
            error=1
            errMsg "brew not installed"
        fi
    fi

    if [[ $error == 1 ]]
    then
        exit 1
    fi
}
