sudo apt-get install vice
wget http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/old/vice-1.5-roms.tar.gz
tar xvzf vice-1.5-roms.tar.gz
cd vice-1.5-roms/data
sudo cp -rv * /usr/lib/vice
