#!/bin/bash

# Update and install frotz
sudo apt-get update
sudo apt-get install -y frotz

# Zeroing working directory
cd ~

# Create directory and go to it
mkdir infocom
cd ~/infocom

# Download files
wget https://github.com/CaptainZalo/Infocom/blob/master/hhgttg.dat
