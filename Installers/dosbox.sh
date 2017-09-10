#!/bin/bash

zenity --info --timeout=2 --text="Installing DosBox..."

sudo apt-get install -y dosbox

# DOSBox icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "DOSBox")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "DOSBox", "icon": "~/PocketInstaller/Icons/dosbox.png", "shell": "dosbox" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

zenity --info --timeout=2 --text="DosBox installed!"
