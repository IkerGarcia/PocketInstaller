#!/bin/bash

echo "Installing Mednafen. This may take a while. Please be patient..."

sudo apt-get install -y mednafen libsdl2-dev

read RES_X RES_Y <<<$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $3, $4}')
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE="/../Configuration/mednafen.cfg"
CONF=$DIR$FILE

cp -R $CONF /home/chip/.mednafen/mednafen*.cfg
CONF2=/home/chip/.mednafen/mednafen*.cfg

sudo sed -i "s/yres 272/yres ${RES_Y}/g" $CONF2
sudo sed -i "s/xres 480/xres ${RES_X}/g" $CONF2

# Mednafen icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "Mednafen")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "Mednafen", "icon": "/usr/local/bin/pocketinstaller/Icons/mednafen.png", "shell": "/home/chip/PocketInstaller/Launchers/mednafront.sh" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "Mednafen installed! Have fun!"
