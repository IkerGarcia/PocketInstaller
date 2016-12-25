# Install Zoom: interactive fiction parser for Z-machine, TADS, & HUGO
wget -O /tmp/zoom.tgz http://www.logicalshift.co.uk/unix/zoom/zoom-1.1.5.tar.gz
tar zxvf /tmp/zoom.tgz -C /home/chip
rm /tmp/zoom.tgz
cd /home/chip/zoom-1.1.5
./configure
patch -p0 < zoom.patch
make
sudo mkdir -p /usr/local/share/zoom/games
sudo make install-strip

# Install a handful of titles to start out with
sudo wget -O /usr/local/share/zoom/games http://mirror.ifarchive.org/if-archive/games/zcode/dreamhold.z8
sudo wget -O /usr/local/share/zoom/games http://mirror.ifarchive.org/if-archive/games/zcode/LostPig.zblorb
sudo wget -O /usr/local/share/zoom/games http://mirror.ifarchive.org/if-archive/games/zcode/ChildsPlay.zblorb
sudo wget -O /usr/local/share/zoom/games http://mirror.ifarchive.org/if-archive/games/zcode/curses.z5
sudo wget -O /usr/local/share/zoom/games http://mirror.ifarchive.org/if-archive/games/zcode/hauntings.z8
sudo wget -O /usr/local/share/zoom/games http://mirror.ifarchive.org/if-archive/games/zcode/Galatea.zblorb
sudo wget -O /usr/local/share/zoom/games http://mirror.ifarchive.org/if-archive/games/zcode/905.z5
sudo wget -O /usr/local/share/zoom/games https://dist.saugus.net/IF/Lighthouse.z8
sudo wget -O /usr/local/share/zoom/games https://dist.saugus.net/IF/Awakening.z8

