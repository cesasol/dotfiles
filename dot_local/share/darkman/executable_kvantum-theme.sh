#!/usr/bin/env sh

# trigger a small, passive popup dialog to inform the user about darkman's activity
# reference https://wiki.archlinux.org/title/Desktop_notifications#Usage_in_programming

case "$1" in
dark) THEME=Kvantum-Tokyo-Night ;;
light) THEME=Layan ;;
default) exit 1 ;;
esac

kvantummanager --set $THEME
