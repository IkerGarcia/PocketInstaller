#!/bin/bash

echo "Installing ColEm. This make take a while. Please be patient..."

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y build-essential zlib1g-dev libx11-dev libxext-dev unrar

# Zeroing working directory
cd ~

# Get source code
wget http://fms.komkon.org/ColEm/ColEm40-Source.zip -O ~/ColEm40-Source.zip

# Unzip
unzip ~/ColEm40-Source.zip

# Clean up
sudo rm -R ~/ColEm40-Source.zip

# Go to build folder
cd ~/ColEm/Unix

# Build
make

# ColEm icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "ColEm")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "ColEm", "icon": "~/PocketInstaller/Icons/colem.png", "shell": "/home/chip/ColEm/Unix/colem" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "ColEm installed!"
