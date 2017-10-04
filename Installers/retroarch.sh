#!/bin/bash

echo "Installing RetroArch. This make take a while. Please be patient..."

cd ~

sudo apt-get update
sudo apt-get install -y build-essential git pkg-config libsdl2-dev libsdl1.2-dev

git clone https://github.com/libretro/RetroArch.git
cd ~/RetroArch

./configure --enable-opengles --disable-oss --disable-sdl --disable-ffmpeg --disable-vg --disable-cg --enable-neon --enable-floathard

make
sudo make install

mkdir ~/.config/retroarch && cp ~/PocketInstaller/Configuration/retroarch.cfg ~/.config/retroarch/retroarch.cfg

cd

git clone https://github.com/libretro/gambatte-libretro.git
cd ~/gambatte-libretro

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

echo "RetroArch installed!"
