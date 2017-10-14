#!/bin/bash

echo "Installing OpenArena (Quake 3). This may take a while. Please be patient..."

# Update and install
sudo apt-get update
sudo apt-get install -y git

# Get code
git clone https://github.com/NextThingCo/ioquake3-gles

# Change Directory
cd ioquake3-gles

# Change access permissions
sudo chmod +x build.sh

# Build
./build.sh

# OpenArena icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "OpenArena")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "OpenArena", "icon": "/usr/local/bin/pocketinstaller/Icons/openarena.png", "shell": "openarena" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "OpenArena (Quake 3) installed. Have fun!"
