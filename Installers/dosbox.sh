#!/bin/bash

echo "Installing DosBox. This may take a while. Please be patient..."

# Update and install
sudo apt-get update
sudo apt-get install -y dosbox

# Get instalation directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE="/../Configuration/dosbox.conf"
CONF=$DIR$FILE

# Put config in directory
cp -R $CONF /home/chip/.dosbox/dosbox*.conf


# DOSBox icon
if test -f ~/.pocket-home/.version; then
  IS_ICON_PRESENT=`jq '.pages[0] | .items[] | select(.name == "DOSBox")' ~/.pocket-home/config.json`
  if [ -z ${IS_ICON_PRESENT} ]
  then
    jq '(.pages[0] | .items) |= . + [{ "name": "DOSBox", "icon": "/usr/local/bin/pocketinstaller/Icons/dosbox.png", "shell": "dosbox" }]' ~/.pocket-home/config.json > tmp.$$.json
    mv tmp.$$.json ~/.pocket-home/config.json
  fi
fi

echo "DosBox installed. Have fun!"
