#!/bin/bash

echo "Installing VICE. This make take a while. Please be patient..."

sudo apt-get install -y vice

wget http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/old/vice-1.5-roms.tar.gz -O /tmp/vice-1.5-roms.tar.gz
tar xvzf /tmp/vice-1.5-roms.tar.gz

cd vice-1.5-roms/data

sudo cp -rv * /usr/lib/vice

mkdir -p /home/chip/.vice

sudo cp ~/PocketInstaller/Configuration/vicerc /home/chip/.vice/vicerc

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

echo "VICE installed!"
