#!/usr/bin/env bash

pp=""
case "$XDG_CURRENT_DESKTOP" in
    "X-Cinnamon")
        pp=$(type -p pinentry-gnome3)
        ;;
    "KDE")
        pp=$(type -p pinentry-qt)
        ;;
esac

exec ${pp:-/usr/bin/pinentry-tty} "$@"
