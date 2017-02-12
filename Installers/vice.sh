#!/bin/bash

sudo apt-get install -y vice

wget http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/old/vice-1.5-roms.tar.gz -O /tmp/vice-1.5-roms.tar.gz
tar xvzf /tmp/vice-1.5-roms.tar.gz 

cd vice-1.5-roms/data

sudo cp -rv * /usr/lib/vice

mkdir -p /home/chip/.vice

sudo cp ~/PocketInstaller/Configuration/vicerc /home/chip/.vice/vicerc

cd -

