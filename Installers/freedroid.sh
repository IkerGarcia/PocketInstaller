#!/bin/bash

echo "Installing Freedroid. This may take a while. Please be patient..."

# Update and install
sudo apt-get update
sudo apt-get install -y freedroid

# Freedroid icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "Freedroid")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "Freedroid", "icon": "/usr/local/bin/pocketinstaller/Icons/freedroid.png", "shell": "/usr/local/bin/pocketinstaller/Launchers/freedroid.sh" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "Freedroid installed. Have fun!"
