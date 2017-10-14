#!/bin/sh

cd /usr/games

path=$(ls)

system=$(eval zenity --list --column Games $path --width=480 --height=272)

case $? in
  0)
    vala-terminal -fs 8 -g 20 20 -e /usr/games/"$system";;
  1)
    echo "No game selected.";;
 -1)
    echo "An unexpected error has occurred.";;
esac
