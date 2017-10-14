#!/bin/bash

echo "Installing Gargoyle. This may take a while. Please be patient..."

# Install Gargoyle: interactive fiction parser for many formats
CHIP_STORY_LOCATION=/usr/local/share/IF
sudo mkdir -p -m 775 "$CHIP_STORY_LOCATION"
sudo chown -R chip "$CHIP_STORY_LOCATION"
./ifstories.py -f "ADRIFT Alan Glulx TADS Z-code" -l "$CHIP_STORY_LOCATION"
sudo apt-get update
sudo apt-get install -y gargoyle-free

# Gargoyle icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "Gargoyle")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "Gargoyle", "icon": "/usr/local/bin/pocketinstaller/Icons/gargoyle.png", "shell": "gargoyle-free" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "Gargoyle installed! Have fun!"
