#!/bin/bash

zenity --info --timeout=2 --text="Installing ZEsarUX..."

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y gcc g++ libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev

# Zeroing working directoy
cd ~

# Download source code
wget https://downloads.sourceforge.net/project/zesarux/ZEsarUX-4.1/ZEsarUX_src-4.1.tar.gz /ZEsarUX_src-4.1.tar.gz

# Extract
tar -xzvf ~/ZEsarUX_src-4.1.tar.gz

# Clean up
sudo rm -R ~/ZEsarUX_src-4.1.tar.gz

# Modify source code
sudo cp -R ~/PocketInstaller/Configuration/scrsdl.c ~/ZEsarUX-4.1/scrsdl.c
sudo cp -R ~/PocketInstaller/Configuration/scrxwindows.c ~/ZEsarUX-4.1/scrxwindows.c

# Compile
cd ~/ZEsarUX-4.1
chmod +x configure
./configure

# Build
make clean
make

# ZEsarUX icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "ZEsarUX")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "ZEsarUX", "icon": "~/PocketInstaller/Icons/zesarux.png", "shell": "/home/chip/zesarux" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

zenity --info --timeout=2 --text="ZEsarUX installed!"
