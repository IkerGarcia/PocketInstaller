#!/bin/bash

sudo apt-get update
sudo apt-get install -y git

git clone https://github.com/NextThingCo/ioquake3-gles

cd ioquake3-gles

sudo chmod +x build.sh

./build.sh




