#!/bin/bash

echo "Installing VICE. This may take a while. Please be patient..."

# Update and install
sudo apt-get update
sudo apt-get install -y vice

# Get code
wget http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/old/vice-1.5-roms.tar.gz -O /tmp/vice-1.5-roms.tar.gz
tar xvzf /tmp/vice-1.5-roms.tar.gz

# Go to data folder
cd vice-1.5-roms/data

# Copy to directory
sudo cp -rv * /usr/lib/vice

# Create config directory
mkdir -p /home/chip/.vice

# Copy config to directory
sudo cp /usr/local/bin/pocketinstaller/Configuration/vicerc /home/chip/.vice/vicerc

# Move to dir
cd -

# VICE icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "VICE")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "VICE", "icon": "/usr/local/bin/pocketinstaller/Icons/vice.png", "shell": "x64" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "VICE installed. Have fun!"
