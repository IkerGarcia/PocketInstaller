#!/bin/bash

echo "Installing Minecraft. This make take a while. Please be patient..."

# Zeroing working dir.
cd ~

# Turned wget to syntax "wget foo -O bar"
wget https://github.com/NextThingCo/chipcraft/archive/master.zip -O ~/master.zip

# Unzip bar
unzip ~/master.zip

# Clean up.
sudo rm -R ~/master.zip

# Go to build folder.
cd ~/chipcraft-master

# Make executable.
sudo chmod +x build.sh

# Build.
./build.sh

# Moving start shellscript to base folder.
mv ~/chipcraft-master/mcpi/start.sh ~/chipcraft-master/start.sh

# Minecraft icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "Minecraft")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "Minecraft", "icon": "~/PocketInstaller/Icons/minecraft.png", "shell": "/home/chip/chipcraft-master/start.sh" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "Minecraft installed!"
