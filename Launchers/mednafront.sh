#!/bin/bash

cd ~/.mednafen/roms

folderpath=$(ls)

system=$(eval zenity --list --column System $folderpath --width=480 --height=272)

if [ "$?" -eq 1 ]; then
echo "Cancelled."
else
cd $system
system="$system-Roms"
files=$(ls -Q)
rom=$(eval zenity --list --column $system $files --width=480 --height=272)

if [ "$?" -eq 1 ]; then
echo "Cancelled."
else
mednafen -fs 1 "$rom"
fi
fi
