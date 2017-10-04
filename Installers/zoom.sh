#!/bin/bash

echo "Installing Zoom. This make take a while. Please be patient..."

# Install Zoom: interactive fiction parser for Z-machine
CHIP_STORY_LOCATION=/usr/local/share/IF
ZOOM_STORY_LOCATION=/usr/local/share/zoom/games
if [ -d "$ZOOM_STORY_LOCATION" ]
then
  sudo cp -pr "$ZOOM_STORY_LOCATION" "$CHIP_STORY_LOCATION"
  sudo rm -rf "$ZOOM_STORY_LOCATION"
  sudo ln -s "$CHIP_STORY_LOCATION" "$ZOOM_STORY_LOCATION"
fi
sudo mkdir -p -m 775 "$CHIP_STORY_LOCATION"
sudo chown -R chip "$CHIP_STORY_LOCATION"
./ifstories.py --formats="Z-code" --library="$CHIP_STORY_LOCATION"
wget -O /tmp/zoom.tgz http://www.logicalshift.co.uk/unix/zoom/zoom-1.1.5.tar.gz
tar zxvf /tmp/zoom.tgz -C /home/chip
rm /tmp/zoom.tgz
cp -p zoom.patch /home/chip/zoom-1.1.5
cd /home/chip/zoom-1.1.5
./configure
patch -p0 < zoom.patch
make
sudo make install-strip

# Clean up when we're done
rm -rf /home/chip/zoom-1.1.5

# Zoom icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "Zoom")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "Zoom", "icon": "/usr/local/bin/pocketinstaller/Icons/zoom.png", "shell": "zoom" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "Zoom installed!"
