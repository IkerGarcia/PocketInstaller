#!/bin/bash

echo "Installing RetroArch. This may take a while. Please be patient..."

# Zeroing working dir.
cd ~

# Update and install
sudo apt-get update
sudo apt-get install -y build-essential git pkg-config libsdl2-dev libsdl1.2-dev

# Clone project
git clone https://github.com/libretro/RetroArch.git

# Go to build folder
cd ~/RetroArch
./configure --enable-opengles --disable-oss --disable-sdl --disable-ffmpeg --disable-vg --disable-cg --enable-neon --enable-floathard

# Build
make
sudo make install

# Create dir and move config files
mkdir ~/.config/retroarch && cp /usr/local/bin/pocketinstaller/Configuration/retroarch.cfg ~/.config/retroarch/retroarch.cfg

# Go to folder
cd

# Cone LibRetro
git clone https://github.com/libretro/gambatte-libretro.git
cd ~/gambatte-libretro

# Build LibRetro
make -f Makefile.libretro

# RetroArch icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "RetroArch")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "RetroArch", "icon": "/usr/local/bin/pocketinstaller/Icons/retroarch.png", "shell": "retroarch" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "RetroArch installed. Have fun!"
