#!/bin/bash

zenity --info --timeout=2 --text="Installing OpenArena (Quake 3)..."

sudo apt-get update
sudo apt-get install -y git

git clone https://github.com/NextThingCo/ioquake3-gles

cd ioquake3-gles

sudo chmod +x build.sh

./build.sh

# OpenArena icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "OpenArena")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "OpenArena", "icon": "~/PocketInstaller/Icons/xx.png", "shell": "openarena" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

zenity --info --timeout=2 --text="OpenArena (Quake 3) installed!"
