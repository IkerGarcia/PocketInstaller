#!/bin/bash

echo "Installing XU4 (Ultima IV). This make take a while. Please be patient..."

# Install XU4: play classic Ultima IV on current hardware
sudo apt-get update
sudo apt-get install -y subversion libxml2-dev libsdl-mixer1.2-dev
svn checkout https://svn.code.sf.net/p/xu4/code/trunk /home/chip/xu4-code
cp -p xu4.patch /home/chip/xu4-code/u4/src
cd /home/chip/xu4-code/u4/src
wget -O ultima4.zip http://www.ultima-universe.com/downloads/ultima4v101.zip
wget -O u4upgrad.zip https://downloads.sourceforge.net/project/xu4/Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip
patch -p0 < xu4.patch
make
strip coord dumpsavegame tlkconv u4 u4dec u4enc u4unpackexe
sudo make install
sudo mv ultima4.zip u4upgrad.zip /usr/local/lib/u4
# Clean up when we're done
rm -rf /home/chip/xu4-code

# XU4 icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "XU4")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "XU4", "icon": "/usr/local/bin/pocketinstaller/icons/xu4.png", "shell": "/home/chip/PocketInstaller/Launchers/xu4.sh" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "XU4 (Ultima IV) installed!"
