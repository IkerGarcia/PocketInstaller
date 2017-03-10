#!/bin/bash

# Install Zoom: interactive fiction parser for Z-machine, TADS, & HUGO

wget -O /tmp/zoom.tgz http://www.logicalshift.co.uk/unix/zoom/zoom-1.1.5.tar.gz
tar zxvf /tmp/zoom.tgz -C /home/chip
rm /tmp/zoom.tgz
cp -p zoom.patch /home/chip/zoom-1.1.5

cd /home/chip/zoom-1.1.5

./configure

patch -p0 < zoom.patch

make

sudo mkdir -p /usr/local/share/zoom/games
sudo make install-strip
# Clean up when we're done

rm -rf /home/chip/zoom-1.1.5

# Install a handful of titles to start out with
sudo wget -O /usr/local/share/zoom/games/dreamhold.z8 http://mirror.ifarchive.org/if-archive/games/zcode/dreamhold.z8
sudo wget -O /usr/local/share/zoom/games/LostPig.z8 http://mirror.ifarchive.org/if-archive/games/zcode/LostPig.z8
sudo wget -O /usr/local/share/zoom/games/curses.z5 http://mirror.ifarchive.org/if-archive/games/zcode/curses.z5
sudo wget -O /usr/local/share/zoom/games/hauntings.z8 http://mirror.ifarchive.org/if-archive/games/zcode/hauntings.z8
sudo wget -O /usr/local/share/zoom/games/905.z5 http://mirror.ifarchive.org/if-archive/games/zcode/905.z5
sudo wget -O /usr/local/share/zoom/games/photopia.z5 http://mirror.ifarchive.org/if-archive/games/zcode/photopia.z5
sudo wget -O /usr/local/share/zoom/games/Tangle.z5 http://mirror.ifarchive.org/if-archive/games/zcode/Tangle.z5
sudo wget -O /usr/local/share/zoom/games/metamorp.z5 http://mirror.ifarchive.org/if-archive/games/zcode/metamorp.z5
sudo wget -O /usr/local/share/zoom/games/pytho.z8 http://mirror.ifarchive.org/if-archive/games/zcode/pytho.z8
sudo wget -O /usr/local/share/zoom/games/shade.z5 http://mirror.ifarchive.org/if-archive/games/zcode/shade.z5
sudo wget -O /usr/local/share/zoom/games/minster.z5 http://mirror.ifarchive.org/if-archive/games/zcode/minster.z5
sudo wget -O /usr/local/share/zoom/games/Balances.z5 http://mirror.ifarchive.org/if-archive/games/zcode/Balances.z5
sudo wget -O /usr/local/share/zoom/games/Jigsaw.z8 http://mirror.ifarchive.org/if-archive/games/zcode/Jigsaw.z8
sudo wget -O /usr/local/share/zoom/games/AllRoads.z5 http://mirror.ifarchive.org/if-archive/games/zcode/AllRoads.z5
sudo wget -O /usr/local/share/zoom/games/anchor.z8 http://mirror.ifarchive.org/if-archive/games/zcode/anchor.z8
sudo wget -O /usr/local/share/zoom/games/Lighthouse.z8 https://dist.saugus.net/IF/Lighthouse.z8
sudo wget -O /usr/local/share/zoom/games/Awakening.z8 https://dist.saugus.net/IF/Awakening.z8

