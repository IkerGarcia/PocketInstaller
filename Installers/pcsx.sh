#!/bin/bash

echo "Installing PCSX. This may take a while. Please be patient..."

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y git build-essential libsdl1.2-dev

# Get code
sudo git clone https://github.com/notaz/pcsx_rearmed.git /home/chip/pcsx_rearmed

# Go to build folder
cd /home/chip/pcsx_rearmed

# Modify
sudo sed -i "/#define MENU_X2/c#define MENU_X2 0" frontend/menu.c

# Update
sudo git submodule update --init
export CFLAGS="-mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon"
sudo ./configure --sound-drivers="sdl"

# Build
sudo make

# Change access permissions
sudo chmod +x pcsx

# Copy to directory
sudo cp pcsx /usr/local/bin

# PCSX icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "PCSX")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "PCSX", "icon": "/usr/local/bin/pocketinstaller/Icons/pcsx.png", "shell": "pcsx" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "PCSX installed. Have fun!"
