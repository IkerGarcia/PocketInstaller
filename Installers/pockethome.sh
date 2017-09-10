#!/bin/bash

sudo apt-get update
sudo apt install -y xinput-calibrator

sudo wget -O install-pockethome http://bit.ly/29uWueR
sudo chmod +x install-pockethome

./install-pockethome

# Correct malformed config json
sed 's/},\s*]/}\n]/' ~/.pocket-home/config.json > tmp.$$.json
mv tmp.$$.json ~/.pocket-home/config.json

sudo apt-mark hold -qq pocket-home

zenity --info --text="Pocket Home (Marshmallow edition) installed, reboot needed"
sudo reboot
