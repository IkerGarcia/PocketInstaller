#!/bin/bash

zenity --info --timeout=2 --text="Installing Freedroid..."

sudo apt-get install -y freedroid

# Freedroid icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "Freedroid")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "Freedroid", "icon": "~/PocketInstaller/Icons/freedroid.png", "shell": "/home/chip/PocketInstaller/Launchers/freedroid.sh" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

zenity --info --timeout=2 --text="Freedroid installed!"
