sudo apt-get install -y vice
wget http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/old/vice-1.5-roms.tar.gz -O /tmp/vice-1.5-roms.tar.gz
tar xvzf /tmp/vice-1.5-roms.tar.gz -C /tmp/
sudo cp -rv /tmp/vice-1.5-roms/data/* /usr/lib/vice

