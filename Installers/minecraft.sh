#!/bin/bash

# Zeroing working dir.
cd ~

# Turned wget to syntax "wget foo -O bar" 
wget https://github.com/NextThingCo/chipcraft/archive/master.zip -O ~/master.zip 

# Unzip bar
unzip ~/master.zip

# Clean up.
sudo rm -R ~/master.zip

# Go to build folder.
cd ~/chipcraft-master

# Make executable.
sudo chmod +x build.sh

# Build.
./build.sh

# Moving start shellscript to base folder.
mv ~/chipcraft-master/mcpi/start.sh ~/chipcraft-master/start.sh

# Pop up installation successful

zenity --info --text="Minecraft installed"

