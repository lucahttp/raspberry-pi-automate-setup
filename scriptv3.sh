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
##pip install virtualenv

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
########    OCTOPRINT
#####

virtualenv OctoPrint
OctoPrint/bin/pip install OctoPrint
./OctoPrint/bin/octoprint
#https://octoprint.org/download/

sudo usermod -a -G tty pi
sudo usermod -a -G dialout pi

#-----
wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.init && sudo mv octoprint.init /etc/init.d/octoprint
wget https://github.com/foosel/OctoPrint/raw/master/scripts/octoprint.default && sudo mv octoprint.default /etc/default/octoprint
sudo chmod +x /etc/init.d/octoprint
#sudo nano /etc/default/octoprint
#-----

#-----
#Remove the # from the front of this line:
#DAEMON=/home/pi/OctoPrint/venv/bin/octoprint
#-----
sudo sed -i '/OctoPrint/s/^#//g' /etc/default/octoprint #works for me insted the before line

sudo update-rc.d octoprint defaults
#sudo service octoprint {start|stop|restart}
sudo service octoprint start




#####
########    OCTOPRINT
##########



##########
########
#####
cd ~
#sudo apt update
sudo apt install -y python3-pip python3-dev python3-setuptools python3-virtualenv git libyaml-dev build-essential
mkdir OctoPrint && cd OctoPrint
virtualenv venv
source venv/bin/activate
pip3 install pip --upgrade -y
pip3 install octoprint
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

#https://stackoverflow.com/questions/24889346/how o-uncomment-a-line hat-contains-a-specific-string-using-sed
#sed -i '/^#.* 2001 /s/^#//' file
#sed -i '/^#.* DAEMON=/home/pi/OctoPrint/venv/bin/octoprint /s/^#//' /etc/default/octoprint

#https://gist.github.com/haisum/4fcd9146b6c972d0d3ca
#sed -i '/<pattern>/s/^/#/g' file #comment
#sed -i '/<pattern>/s/^#//g' file #uncomment

##sed -i '/DAEMON=/home/pi/OctoPrint/venv/bin/octoprint/s/^#//g' /etc/default/octoprint #uncomment
sudo sed -i '/OctoPrint/s/^#//g' /etc/default/octoprint #works for me insted the before line

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

sudo apt install   -y mosquitto mosquitto-clients
sudo systemctl enable mosquitto.service
mosquitto -v
hostname -I

## Install NodeRed
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
#apt-get install   -y nodered
sudo systemctl enable nodered.service



##########
#####   Install LAMPP
##


# APACHE
sudo apt install -y apache2

#cd /var/www/
#sudo chown -R www-data:www-data html
#sudo find html  ype d -print -exec chmod 775 {} \;
#sudo find html  ype f -print -exec chmod 664 {} \;

cd /var/www/
sudo chown -R www-data:www-data html
sudo find html -type d -print -exec chmod 775 {} \;
sudo find html -type f -print -exec chmod 664 {} \;

sudo usermod -a -G www-data pi

#cat > /var/www/html/index.php << "EOF"
#<?php phpinfo(); ?>
#EOF


# PHP
sudo apt install -y php7.1 php7.1-mysql libapache2-mod-php7.1
sudo /etc/init.d/apache2 restart
sudo /etc/init.d/apache2 status

# MariaDB

sudo apt install -y mariadb-server
#mysql -u user -p
/etc/init.d/apache2 restart
#https://linuxize.com/post/how o-create-mysql-user-accounts-and-grant-privileges/


##
#####   CHECKED
##########

## Finish

echo "Install complete, rebooting."
reboot

#######################################################################################################


#https://www.gngrninja.com/code/2019/3/10/raspberry-pi-headless-setup-with-wifi-and-ssh-enabled


#https://gist.github.com/haisum/4fcd9146b6c972d0d3ca



nano /home/pi/OctoPrintOverDebian.service


[Unit]
Description=OctoPrint over Debian service  
After=network-online.target

[Service]
ExecStart=/home/pi/OctoPrint/bin/octoprint serve
WorkingDirectory=/home/pi/OctoPrint/bin/octoprint
StandardOutput=inherit
StandardError=inherit
Restart=always
User=pi

[Install]
WantedBy=multi-user.target


sudo cp /home/pi/OctoPrintOverDebian.service /lib/systemd/system/



sudo nano /etc/rc.local
# append in the last line
sudo service octoprint start



#https://www.raspberrypi.org/forums/viewtopic.php?t=197513  
#https://domoticproject.com/creating-raspberry-pi-service/
#https://raspberrypi.stackexchange.com/questions/8734/execute-script-on-start-up