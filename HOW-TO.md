**Add repositories**

sudo nano /etc/apt/sources.list

Add these lines to the end:

deb http://pkg.bunsenlabs.org/debian bunsen-hydrogen main

deb http://pkg.bunsenlabs.org/debian jessie-backports main

**Install YAD**

sudo apt-get update
sudo apt-get install YAD

After this you can just remove the lines added previously to the sources.list file, will usually be slower.

**Install Zenity**

sudo apt-get install zenity

**Run the GUI**

When you want to install something just go to the folder where this project is stored and run ./PocketInstaller.sh
If any of the available programs is installed, you won't see it available for the installation.

**Install Pocket Home (by @o-marshmallow) (optional)**

The experience with this tool, and with the Pocket C.H.I.P will be greater with Pocket Home installed:
wget -O install-pockethome http://bit.ly/29uWueR
chmod +x install-pockethome
./install-pockethome

Now you can create icons for the installed programs, see the forums for more information:
https://bbs.nextthing.co/t/pocket-home-marshmallow-edition/6579

The scripts that run the different programs can be found in the Launchers folder.

**Copy config files**

Config files (with resolution, keys mapped, etc.) can be found in the Configuration folder. Just replace the original ones with this versions.

