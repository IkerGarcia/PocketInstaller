#!/bin/bash

echo "Installing GnGeo. This may take a while. Please be patient..."

# Update and install
sudo apt-get update
sudo apt-get install -y build-essential

# Get source code
sudo wget -O /tmp/gngeo.tar.gz http://pocketinstaller.damianvila.com/gngeo.tar.gz

# Untar
sudo tar -zxvf /tmp/gngeo.tar.gz -C /home/chip/

# Clean up
sudo rm -r /tmp/gngeo.tar.gz

# Go to build folder
cd /home/chip/gngeo-0.8

# Build
sudo ./configure
sudo make
sudo make install

# GnGeo icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "GnGeo")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "GnGeo", "icon": "/usr/local/bin/pocketinstaller/Icons/gngeo.png", "shell": "gngeo" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "GnGeo installed. Have fun!"
