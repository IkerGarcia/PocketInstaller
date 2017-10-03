#!/bin/bash

echo "Installing Freedroid. This make take a while. Please be patient..."

sudo apt-get install -y freedroid

# Freedroid icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "Freedroid")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "Freedroid", "icon": "/usr/local/bin/pocketinstaller/icons/freedroid.png", "shell": "/home/chip/PocketInstaller/Launchers/freedroid.sh" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "Freedroid installed!"
