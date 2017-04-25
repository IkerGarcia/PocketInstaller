#!/bin/bash
# Install Gargoyle: interactive fiction parser for many formats
CHIP_STORY_LOCATION=/usr/local/share/IF
sudo mkdir -p -m 775 "$CHIP_STORY_LOCATION"
sudo chown -R chip "$CHIP_STORY_LOCATION"
./ifstories.py -f "ADRIFT Alan Glulx TADS Z-code" -l "$CHIP_STORY_LOCATION"
sudo apt-get update
sudo apt-get install -y gargoyle-free

