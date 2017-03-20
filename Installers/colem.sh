#!/bin/bash

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y build-essential zlib1g-dev libx11-dev libxext-dev unrar

# Zeroing working directory
cd ~

# Get source code 
wget http://fms.komkon.org/ColEm/ColEm40-Source.zip -O ~/ColEm40-Source.zip

# Unzip 
unzip ~/ColEm40-Source.zip

# Clean up
sudo rm -R ~/ColEm40-Source.zip

# Go to build folder
cd ~/ColEm/Unix

# Build
make



