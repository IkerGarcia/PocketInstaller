echo "installing xinput-calibrator "
sudo apt install -y xinput-calibrator > /dev/null
echo "Setting up Pocket Home"
wget -O install-pockethome http://bit.ly/29uWueR -C /tmp/
sh /tmp/install-pockethome
echo "Done"

