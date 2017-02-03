#!/bin/bash

sudo apt-get install -y git build-essential libsdl1.2-dev

sudo git clone https://github.com/notaz/pcsx_rearmed.git /home/chip/pcsx_rearmed

cd /home/chip/pcsx_rearmed

sudo sed -i "/#define MENU_X2/c#define MENU_X2 0" frontend/menu.c

sudo git submodule update --init
export CFLAGS="-mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon"
sudo ./configure --sound-drivers="sdl"
sudo make

sudo chmod +x pcsx

sudo cp pcsx /usr/local/bin


