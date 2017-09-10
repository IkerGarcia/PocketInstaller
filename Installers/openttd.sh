#!/bin/bash

zenity --info --timeout=2 --text="Installing OpenTTD..."

sudo apt-get install -y openttd

# OpenTTD icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "OpenTTD")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "OpenTTD", "icon": "~/PocketInstaller/Icons/openttd.png", "shell": "/home/chip/PocketInstaller/Launchers/openttd.sh" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

zenity --info --timeout=2 --text="OpenTTD installed!"
