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
wget https://github.com/CaptainZalo/Infocom/blob/master/zork1.dat 
wget https://github.com/CaptainZalo/Infocom/blob/master/zork2.dat 
wget https://github.com/CaptainZalo/Infocom/blob/master/zork3.dat 
