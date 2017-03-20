#!/bin/bash

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y gcc g++ libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev

# Zeroing working directoy
cd ~

# Download source code
wget https://downloads.sourceforge.net/project/zesarux/ZEsarUX-4.1/ZEsarUX_src-4.1.tar.gz /ZEsarUX_src-4.1.tar.gz

# Extract
tar -xzvf ~/ZEsarUX_src-4.1.tar.gz

# Clean up
sudo rm -R ~/ZEsarUX_src-4.1.tar.gz

# Modify source code
sudo cp -R ~/PocketInstaller/Configuration/scrsdl.c ~/ZEsarUX-4.1/scrsdl.c
sudo cp -R ~/PocketInstaller/Configuration/scrxwindows.c ~/ZEsarUX-4.1/scrxwindows.c

# Compile
cd ~/ZEsarUX-4.1
chmod +x configure
./configure

# Build
make clean
make




