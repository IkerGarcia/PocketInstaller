#!/bin/bash
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

