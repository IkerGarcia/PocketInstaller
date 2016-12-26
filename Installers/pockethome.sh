sudo apt-get update
sudo apt install -y xinput-calibrator
sudo wget -O install-pockethome http://bit.ly/29uWueR
sudo chmod +x install-pockethome
./install-pockethome

sudo apt-mark hold -qq pocket-home

zenity --info --text="Pocket Home (Marshmallow edition) installed, reboot needed"
sudo reboot

