#!/bin/bash
# Install XU4: play classic Ultima IV on current hardware
sudo apt-get install subversion libxml2-dev libsdl-mixer1.2-dev
svn checkout https://svn.code.sf.net/p/xu4/code/trunk /home/chip/xu4-code
cp -p xu4.patch /home/chip/xu4-code/u4/src
cd /home/chip/xu4-code/u4/src
wget -O ultima4.zip http://www.ultima-universe.com/downloads/ultima4v101.zip
wget -O u4upgrade.zip https://downloads.sourceforge.net/project/xu4/Ultima%204%20VGA%20Upgrade/1.3/u4upgrad.zip
patch -p0 < xu4.patch
make
strip coord dumpsavegame tlkconv u4 u4dec u4enc u4unpackexe
sudo make install
sudo mv ultima4.zip u4upgrad.zip /usr/local/lib/u4
# Clean up when we're done
rm -rf /home/chip/xu4-code

