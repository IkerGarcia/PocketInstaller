#!/bin/bash

echo "Installing GnGeo. This may take a while. Please be patient..."

sudo wget -O /tmp/gngeo.tar.gz https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/gngeo/gngeo-0.8.tar.gz
sudo tar -zxvf /tmp/gngeo.tar.gz -C /home/chip/
sudo rm -r /tmp/gngeo.tar.gz

cd /home/chip/gngeo-0.8

sudo ./configure
sudo make
sudo make install

# GnGeo icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "GnGeo")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "GnGeo", "icon": "/usr/local/bin/pocketinstaller/Icons/gngeo.png", "shell": "gngeo" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "GnGeo installed! Have fun!"
