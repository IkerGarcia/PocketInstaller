# Install Pcsx
# https://bbs.nextthing.co/t/pocketchip-does-psx-and-its-playable-4-4-accelerated-update/11198/3

# Save our current directory
SCRIPT_DIR=$(pwd)

sudo apt-get install -y git build-essential libsdl1.2-dev
git clone https://github.com/notaz/pcsx_rearmed.git pcsx_rearmed
cd pcsx_rearmed

#Fix for huge fonts
#https://github.com/notaz/pcsx_rearmed/issues/76
#P.s could also use this to change the default bios path :D
sed -i "/#define MENU_X2/c#define MENU_X2 0" frontend/menu.c

git submodule update --init
export CFLAGS="-mcpu=cortex-a8 -mtune=cortex-a8 -mfpu=neon"
./configure --sound-drivers="sdl"
make

#this will generate pcsx script, make it executable
chmod +x pcsx

# Move into /usr/local/bin to allow to be run from anywhere
cp pcsx /usr/local/bin

#Return back to our directory
cd $SCRIPT_DIR
