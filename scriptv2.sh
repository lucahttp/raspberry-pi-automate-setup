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

sudo apt install python3-pip

################################################################################################
pip install virtualenv

pip3 install virtualenv

##PIP
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py

##PIPX
#python3 -m pip install --user pipx
#python3 -m pipx ensurepath

#VirtualEnv
##pipx install virtualenv
##virtualenv --help



##########
########
#####
cd ~
sudo apt update
sudo apt install -y python-pip python-dev python-setuptools python-virtualenv git libyaml-dev build-essential
mkdir OctoPrint && cd OctoPrint
virtualenv venv
source venv/bin/activate
pip install pip --upgrade -y
pip install octoprint
sudo usermod -a -G tty pi
sudo usermod -a -G dialout pi
#~/OctoPrint/venv/bin/octoprint serve
#-----
wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.init && sudo mv octoprint.init /etc/init.d/octoprint
wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.default && sudo mv octoprint.default /etc/default/octoprint
sudo chmod +x /etc/init.d/octoprint
#sudo nano /etc/default/octoprint
#-----
#Remove the # from the front of this line:
#DAEMON=/home/pi/OctoPrint/venv/bin/octoprint
#-----

#https://stackoverflow.com/questions/24889346/how-to-uncomment-a-line-that-contains-a-specific-string-using-sed
#sed -i '/^#.* 2001 /s/^#//' file
#sed -i '/^#.* DAEMON=/home/pi/OctoPrint/venv/bin/octoprint /s/^#//' /etc/default/octoprint

#https://gist.github.com/haisum/4fcd9146b6c972d0d3ca
#sed -i '/<pattern>/s/^/#/g' file #comment
#sed -i '/<pattern>/s/^#//g' file #uncomment

sed -i '/DAEMON=/home/pi/OctoPrint/venv/bin/octoprint/s/^#//g' /etc/default/octoprint #uncomment

sudo update-rc.d octoprint defaults
#sudo service octoprint {start|stop|restart}
sudo service octoprint start
#-----
##http://raspberrypi:5000 

#####
#######
#########


#echo "<?php phpinfo(); ?>" >> /var/www/html/index.php

## Install MQTT

sudo apt install -t -y mosquitto mosquitto-clients
sudo systemctl enable mosquitto.service
mosquitto -v
hostname -I

## Install NodeRed
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
#apt-get install -t -y nodered
sudo systemctl enable nodered.service



## Install LAMPP

# APACHE
sudo apt install -t -y apache2

cd /var/www/
sudo chown -R www-data:www-data html
sudo find html -type d -print -exec chmod 775 {} \;
sudo find html -type f -print -exec chmod 664 {} \;

usermod -a -G www-data pi

cat > /var/www/html/index.php << "EOF"
<?php phpinfo(); ?>
EOF


# PHP
sudo apt install -t -y php7.1 php7.1-mysql libapache2-mod-php7.1
sudo /etc/init.d/apache2 restart
sudo /etc/init.d/apache2 status

# MariaDB

sudo apt install -t -y mariadb-server
#mysql -u user -p
/etc/init.d/apache2 restart
#https://linuxize.com/post/how-to-create-mysql-user-accounts-and-grant-privileges/

## Finish

echo "Install complete, rebooting."
reboot

#######################################################################################################


#https://www.gngrninja.com/code/2019/3/10/raspberry-pi-headless-setup-with-wifi-and-ssh-enabled


#https://gist.github.com/haisum/4fcd9146b6c972d0d3ca