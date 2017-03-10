#!/bin/bash

sudo wget -O /tmp/gngeo.tar.gz https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/gngeo/gngeo-0.8.tar.gz
sudo tar -zxvf /tmp/gngeo.tar.gz -C /home/chip/
sudo rm -r /tmp/gngeo.tar.gz

cd /home/chip/gngeo-0.8

sudo ./configure
sudo make
sudo make install
