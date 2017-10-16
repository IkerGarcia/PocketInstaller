#!/bin/bash

echo "Installing ZEsarUX. This may take a while. Please be patient..."

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y build-essential gcc g++ libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev

# Zeroing working directoy
cd ~

# Download source code
wget http://pocketinstaller.damianvila.com/ZEsarUX.tar.gz /ZEsarUX.tar.gz

# Extract
tar -xzvf ~/ZEsarUX.tar.gz

# Clean up
sudo rm -R ~/ZEsarUX.tar.gz

# Modify source code
sudo cp -R /usr/local/bin/pocketinstaller/Configuration/scrsdl.c ~/ZEsarUX-5.0/scrsdl.c
sudo cp -R /usr/local/bin/pocketinstaller/Configuration/scrxwindows.c ~/ZEsarUX-5.0/scrxwindows.c

# Compile
cd ~/ZEsarUX-5.0
chmod +x configure
./configure

# Build
make clean
make

# Get instalation directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE="/../Configuration/zesaruxrc"
CONF=$DIR$FILE

# Put config in directory
cp -R $CONF /home/chip/.zesaruxrc

# ZEsarUX icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "ZEsarUX")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "ZEsarUX", "icon": "/usr/local/bin/pocketinstaller/Icons/zesarux.png", "shell": "/usr/local/bin/pocketinstaller/Launchers/zesarux.sh" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "ZEsarUX installed. Have fun!"
