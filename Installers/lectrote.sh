#!/bin/bash

echo "Installing Lectrote. This make take a while. Please be patient..."

# Install Lectrote: interactive fiction parser for Z-machine, Glulx, & Hugo
CHIP_STORY_LOCATION=/usr/local/share/IF
sudo mkdir -p -m 775 "$CHIP_STORY_LOCATION"
sudo chown -R chip "$CHIP_STORY_LOCATION"
./ifstories.py --formats="Glulx Hugo Z-code" --library="$CHIP_STORY_LOCATION"
# Weirdly installing the more current version breaks things;
# the following three lines though show how to do it.
#wget -q -O - https://deb.nodesource.com/setup_6.x | sudo -E bash -
#sudo apt-get update
#sudo apt-get install -y git libnss3 nodejs
sudo apt-get update
sudo apt-get install -y git libnss3 nodejs nodejs-legacy npm
wget -O /tmp/lectrote.tgz https://github.com/erkyrath/lectrote/archive/lectrote-1.2.5.tar.gz
tar zxvf /tmp/lectrote.tgz -C /home/chip
rm /tmp/lectrote.tgz
cp -p lectrote.patch /home/chip/lectrote-lectrote-1.2.5
cd /home/chip/lectrote-lectrote-1.2.5
patch -p0 < lectrote.patch
sudo npm install -g
# Clean up when we're done
rm -rf /home/chip/lectrote-lectrote-1.2.5

# Lectrote icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "Lectrote")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "Lectrote", "icon": "/usr/local/bin/pocketinstaller/icons/lectrote.png", "shell": "lectrote" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "Lectrote installed!"
