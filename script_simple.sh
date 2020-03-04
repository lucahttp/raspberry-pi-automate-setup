#!/bin/sh
# installer.sh will install the necessary packages to get the gifcam up and running with 
# basic functions

# Install packages
PACKAGES="git build-essential python3-pip python-pip"
apt-get update
apt-get upgrade -y
apt-get install $PACKAGES -y

## Install NodeRed
#sh curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered
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

mkdir /var/www/html
chown www-data:www-data /var/www/html
find /var/www/html -type d -print -exec chmod 775 {} \;
find /var/www/html -type f -print -exec chmod 664 {} \;
usermod -aG www-data pi
cat > /var/www/html/index.php << "EOF"
<?php phpinfo(); ?>
EOF



# PHP
sudo apt install -y php7.1 php7.1-mysql libapache2-mod-php7.1
sudo /etc/init.d/apache2 restart
sudo /etc/init.d/apache2 status

# MariaDB

sudo apt install -y mariadb-server
#mysql -u user -p
/etc/init.d/apache2 restart
#https://linuxize.com/post/how o-create-mysql-user-accounts-and-grant-privileges/

mysql -e "CREATE USER 'test'@'%' IDENTIFIED BY 'test';"
mysql -e "GRANT ALL PRIVILEGES ON test TO 'test'@'%';"

#sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
#sed 's/Linux/Unix/' linuxgeek.txt
sudo sed 's/127.0.0.1/0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

#sudo find / -name my.cnf

sudo service mysql restart
##
#####   CHECKED
##########

## Finish

echo "Install complete, rebooting."
reboot

#######################################################################################################
