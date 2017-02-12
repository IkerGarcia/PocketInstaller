#!/bin/bash

sudo apt-get install -y mednafen libsdl2-dev 

read RES_X RES_Y <<<$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $3, $4}')
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FILE="/../Configuration/mednafen.cfg"
CONF=$DIR$FILE

cp -R $CONF /home/chip/.mednafen/mednafen*.cfg
CONF2=/home/chip/.mednafen/mednafen*.cfg

sudo sed -i "s/yres 272/yres ${RES_Y}/g" $CONF2
sudo sed -i "s/xres 480/xres ${RES_X}/g" $CONF2


