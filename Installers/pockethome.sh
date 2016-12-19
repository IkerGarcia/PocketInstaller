sudo wget -O install-pockethome http://bit.ly/29uWueR
sudo chmod +x install-pockethome
./install-pockethome

sudo apt-mark hold -qq pocket-home

echo "Pocket Home (Marshmallow edition) installed, reboot needed"
sleep 3
sudo reboot

