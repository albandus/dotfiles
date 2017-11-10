#!/usr/bin/env bash

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
