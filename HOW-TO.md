**Install**

sudo wget -O ipi.sh http://bit.ly/pokeinst

sudo chmod +x ipi.sh

./ipi.sh

**Run the GUI**

Just go to the PocketInstaller folder and run:
./PocketInstaller.sh

If you already have installed any of the offered systems it won't be offered to install.

After installing Pocket Home (Marshmallow Edition) you should consider creating a desktop icon (with the icon provided in the PocketInstaller folder) and the following command:

vala-terminal -fs 8 -g 20 20 -e ~/PocketInstaller/PocketInstaller.sh

**Launchers**

Most of the offered systems will have a launcher that you can execute or add as a command for an icon. They can be found in ~/PocketInstaller/PocketInstaller.sh

Some systems don't have any launcher as they are run easily, just with one command.

Doom: prboom
DOSBox: dosbox
Minecraft: ~/chipcraft-master/start.sh
Quake III: openarena

**Configuration files**

Configuration files now are automatically copied into the required folders, even with screen resolution checking! However, if needed just look at ~/PocketInstaller/Configuration

**Update**

Just run in the folder that it's stored:

./ipi.sh

If it has been deleted repeat the installation procedure.

**Following instructions are deprecated since v3.0**


~~**Run the GUI**

~~When you want to install something just go to the folder where this project is stored and run ./PocketInstaller.sh
If any of the available programs is installed, you won't see it available for the installation.

~~**Install Pocket Home (by @o-marshmallow) (optional)**

~~The experience with this tool, and with the Pocket C.H.I.P will be greater with Pocket Home installed:
wget -O install-pockethome http://bit.ly/29uWueR
chmod +x install-pockethome
./install-pockethome

~~Now you can create icons for the installed programs, see the forums for more information:
https://bbs.nextthing.co/t/pocket-home-marshmallow-edition/6579

~~The scripts that run the different programs can be found in the Launchers folder.

~~**Copy config files**

~~Config files (with resolution, keys mapped, etc.) can be found in the Configuration folder. Just replace the original ones with this versions.

**Documentation**

Some of the games feature getting started guides. These can be viewed in place with a Web browser, or can be installed
on your PocketC.H.I.P. where they'll be integrated in with your regular Getting Started Help. To install these, run
./InstallDocs.py from within the Documentation directory.
