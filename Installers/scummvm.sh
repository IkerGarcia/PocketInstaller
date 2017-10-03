#!/bin/bash

echo "Installing ScummVM. This make take a while. Please be patient..."

sudo apt-get install -y scummvm

# ScummVM icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "ScummVM")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "ScummVM", "icon": "/usr/local/bin/pocketinstaller/icons/scummvm.png", "shell": "/home/chip/PocketInstaller/Launchers/scummvm.sh" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "ScummVM installed!"
