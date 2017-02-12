#!/bin/sh

cd /usr/games/bsdgames

path=$(ls)

system=$(eval zenity --list --column Games $path --width=480 --height=272)

case $? in
         0)
                ./"$system";;
         1)
                echo "No game selected.";;
        -1)
                echo "An unexpected error has occurred.";;
esac
