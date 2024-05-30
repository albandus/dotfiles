#!/usr/bin/env bash

pp=""
if [[ ! -z "$DISPLAY" ]]
then
    case "$XDG_CURRENT_DESKTOP" in
        "X-Cinnamon")
            pp=$(type -p pinentry-gnome3)
            ;;
        "KDE")
            pp=$(type -p pinentry-qt)
            ;;
    esac
fi

exec ${pp:-/usr/bin/pinentry-tty} "$@"
