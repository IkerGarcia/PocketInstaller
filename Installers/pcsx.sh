#!/bin/bash

echo "Installing PCSX. This may take a while. Please be patient..."

sudo apt-get install -y git build-essential libsdl1.2-dev

sudo git clone https://github.com/notaz/pcsx_rearmed.git /home/chip/pcsx_rearmed

cd /home/chip/pcsx_rearmed

sudo sed -i "/#define MENU_X2/c#define MENU_X2 0" frontend/menu.c

sudo git submodule update --init
export CFLAGS="-mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon"
sudo ./configure --sound-drivers="sdl"
sudo make

sudo chmod +x pcsx

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

echo "PCSX installed! Have fun!"
