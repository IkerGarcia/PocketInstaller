#!/bin/bash

cd ~

sudo apt-get update
sudo apt-get install -y build-essential git pkg-config libsdl2-dev libsdl1.2-dev

git clone https://github.com/libretro/RetroArch.git
cd ~/RetroArch

./configure --enable-opengles --disable-oss --disable-sdl --disable-ffmpeg --disable-vg --disable-cg --enable-neon --enable-floathard

make
sudo make install

mkdir ~/.config/retroarch && cp ~/PocketInstaller/Configuration/retroarch.cfg ~/.config/retroarch/retroarch.cfg

cd 

git clone https://github.com/libretro/gambatte-libretro.git
cd ~/gambatte-libretro

make -f Makefile.libretro



