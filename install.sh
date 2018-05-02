#!/usr/bin/env bash

echo "--- Good morning, master. Let's get to work. Installing now. ---"

echo "--- Updating packages list ---"
sudo apt-get update -qq

echo "--- Removing unused packages ---"
sudo apt-get autoremove -qq

# Use local MySQL so your DB doesn't get wiped when you destroy
# echo "--- MySQL time ---"
# sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
# sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
# sudo apt-get isntall -y mysql-server-5.5

echo "--- Installing base packages ---"
sudo apt-get install -yq nano vim curl python-software-properties git-core bash-completion apache2

# echo "--- Updating packages list ---"
# sudo apt-get update -qq

echo "--- Installing PHP-specific packages ---"
sudo apt-get install -yq php5 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-mysql

echo "--- Installing and configuring Xdebug ---"
sudo apt-get install -yq php5-xdebug

# Reset XDebug config
sudo sed -ni '1p' /etc/php5/conf.d/xdebug.ini
cat << EOF | sudo tee -a /etc/php5/conf.d/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
xdebug.default_enable=1
xdebug.remote_autostart=0
xdebug.remote_connect_back=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_port=9000
EOF

echo "--- Enabling mod-rewrite ---"
sudo a2enmod rewrite

echo "--- What developer codes without errors turned on? Not you, master. ---"
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo "-- Configure Apache"
echo "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
# sudo sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www|' /etc/apache2/sites-enabled/000-default
# See: https://stackoverflow.com/questions/723157
# sudo sed -i $'s|ServerAdmin webmaster@localhost\\\n\\\n|ServerAdmin webmaster@localhost\\\n\\\tServerName localhost\\\n\\\n|' /etc/apache2/sites-enabled/000-default
sudo cp -r /vagrant/vhosts/* /etc/apache2/sites-enabled/

echo "--- Restarting Apache ---"
sudo service apache2 restart

echo "--- Composer is the future. But you knew that, didn't you master? Nice job. ---"
if hash compose 2>/dev/null; then
  composer self-update
else
  cd ~
  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer
fi

echo "--- Add home dir files like bash config ---"
sudo cp -r /vagrant/home/. /home/vagrant
sudo chown -R vagrant /home/vagrant
sudo chgrp -R vagrant /home/vagrant 
sudo cp -r /vagrant/home/. /root
sudo chown -R root /root
sudo chgrp -R root /root 

# Other Stuff

echo "--- All set to go! Would you like to play a game? ---"

# echo "-- Installing IonCube --"
# cd /usr/local
# sudo wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
# sudo tar xzf ioncube_loaders_lin_x86-64.tar.gz
# sudo mkdir -p /opt/sp/php5.3/lib/php/extensions/ioncube/
# sudo cp ioncube/ioncube_loader_lin_5.3.so /opt/sp/php5.3/lib/php/extensions/ioncube/
# sudo bash -c 'echo "zend_extension=/opt/sp/php5.3/lib/php/extensions/ioncube/ioncube_loader_lin_5.3.so" > /etc/php5/conf.d/0-ioncube.ini'
# sudo service apache2 restart
