#!/bin/bash

echo "Installing Doom. This may take a while. Please be patient..."

# Update and install
sudo apt-get update
sudo apt-get install -y prboom doom-wad-shareware

# Add icons
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "Doom")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "Doom", "icon": "/usr/local/bin/pocketinstaller/Icons/doom.png", "shell": "prboom" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "Doom installed. Have fun!"
