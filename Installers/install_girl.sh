#!/bin/bash
# Installer script v0.1. Intended for Debian ARM-based SoC-distribution and GIRL v9.5.0. http://girl.software
# Check if Synaptic packagemanager is installed.
set -e
if ! hash apt-get 2>/dev/null; then
        echo "Sorry. This script requires a distribution with Synaptic package manager (Debian distributions)."
        exit 1
fi
# Check if script is ran in root context.
if [ "$(id -u)" -ne "0" ]; then
        echo "This script requires root."
        exit 1
fi
# Update repositories.
sudo apt-get -y update
# Install build dependencies.
sudo apt-get -y install pkg-config gcc gtk+-2.0 glib-2.0 libgnome-2.0 libgnomeui-dev intltool itstool streamripper audacious
# Control will enter here if $DIRECTORY exists.
# Get GIRL 9.5.2 source tarball, unzip and configure.
cd /tmp/
wget http://download.gnome.org/sources/girl/9.5/girl-9.5.2.tar.xz -O /tmp/girl.tar.xz
tar Jxvf /tmp/girl*
cd /tmp/girl-*
./configure
# Compile with Totem as default player:
# make
# Compile wih Audacity. Replace audacity with preferred audio-player. Personal preferences apply.
make -e GIRL_HELPER_PLAYER=/usr/bin/audacious
sudo make install
# Clean /tmp/ for girl residue. (Thanks Iker)
sudo rm -rf /tmp/girl-*

