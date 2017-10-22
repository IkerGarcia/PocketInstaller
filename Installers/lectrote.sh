#!/bin/bash

echo "Installing Lectrote. This may take a while. Please be patient..."

# Create and set directories
CHIP_STORY_LOCATION=/usr/local/share/IF
sudo mkdir -p -m 775 "$CHIP_STORY_LOCATION"
sudo chown -R chip "$CHIP_STORY_LOCATION"
. /usr/local/bin/pocketinstaller/Installers/ifstories.py --formats="Glulx Hugo Z-code" --library="$CHIP_STORY_LOCATION"

# Weirdly installing the more current version breaks things;
# the following three lines though show how to do it.
#wget -q -O - https://deb.nodesource.com/setup_6.x | sudo -E bash -
#sudo apt-get update
#sudo apt-get install -y git libnss3 nodejs

# Update and install Lectrote: interactive fiction parser for Z-machine, Glulx, & Hugo
sudo apt-get update
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y git libnss3 nodejs nodejs-legacy npm

# Get source code
wget -O /tmp/lectrote.tgz https://github.com/erkyrath/lectrote/archive/lectrote-1.2.9.tar.gz

# Untar
tar zxvf /tmp/lectrote.tgz -C /home/chip

# Clean up
rm /tmp/lectrote.tgz

# Put patch
cp -p /usr/local/bin/pocketinstaller/Installers/lectrote.patch /home/chip/lectrote-lectrote-1.2.9

# Go to build folder
cd /home/chip/lectrote-lectrote-1.2.9
patch -p0 < lectrote.patch
sudo npm install -g

# Clean up when we're done
rm -rf /home/chip/lectrote-lectrote-1.2.9

# Lectrote icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "Lectrote")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "Lectrote", "icon": "/usr/local/bin/pocketinstaller/Icons/lectrote.png", "shell": "lectrote" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "Lectrote installed. Have fun!"
