#!/bin/bash

echo "Installing ScummVM. This may take a while. Please be patient..."

# Update and install
sudo apt-get update
sudo apt-get install -y scummvm

# ScummVM icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "ScummVM")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "ScummVM", "icon": "/usr/local/bin/pocketinstaller/Icons/scummvm.png", "shell": "/usr/local/bin/pocketinstaller/Launchers/scummvm.sh" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "ScummVM installed. Have fun!"
