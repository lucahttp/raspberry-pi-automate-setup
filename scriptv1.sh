#!/bin/sh
# installer.sh will install the necessary packages to get the gifcam up and running with 
# basic functions

# Install packages
PACKAGES="build-essential python-pip"
LAMP="apache2"
rpi-update
apt-get update
apt-get upgrade -y
apt-get install $PACKAGES -y
pip install twython


#echo "<?php phpinfo(); ?>" >> /var/www/html/index.php


## Install NodeRed
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

sudo systemctl enable nodered.service

## Finish

echo "Install complete, rebooting."
reboot

#######################################################################################################


