#!/bin/sh
# Add any extra stuff you might need here.

root_profile="/root/.profile"
apache_config_file="/etc/apache2/apache2.conf"
redis_config_file="/etc/redis/redis.conf"

# To prevent warnings like "stdin: is not a tty"
sed -i "s/^mesg n$/tty -s \&\& mesg n/g" ${root_profile}

ex +"%s@DPkg@//DPkg" -cwq /etc/apt/apt.conf.d/70debconf
dpkg-reconfigure debconf -f noninteractive -p critical

# Update the server
apt-get update
apt-get -y upgrade

# Install basic tools
echo "Build essentials"
apt-get -y install build-essential binutils-doc git

# Install Redis Server [For caching several apps]
apt-get -y install redis-server
sed -i "s/bind 127.0.0.1/bind 0.0.0.0/g" ${redis_config_file}

# Install Beanstalkd
echo "Installing Beanstalkd"
apt-get -y install beanstalkd

# Install Apache
echo "Installing Apache2"
apt-get -y install apache2
a2enmod rewrite
sed -i "s/AllowOverride None/AllowOverride All/g" ${apache_config_file}

# Install PHP
echo "Installing PHP7"
apt-get -y install php php-curl php-mysql php-sqlite3 php-xdebug php-mcrypt php-imagick php-pgsql php-zip php-gd php-intl php-mbstring php-xml php-xdebug libapache2-mod-php
phpenmod mcrypt xdebug

php_version=$(php -r "echo phpversion();" | egrep -o '[7-9]{1,}\.[0-9]{1,}')
php_config_file="/etc/php/$php_version/apache2/php.ini"
xdebug_config_file="/etc/php/$php_version/mods-available/xdebug.ini"

sed -i "s/error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/g" ${php_config_file}
sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" ${php_config_file}
sed -i "s/display_errors = Off/display_errors = On/g" ${php_config_file}
sed -i "s/short_open_tag = Off/short_open_tag = On/g" ${php_config_file}
sed -i "s/;date.timezone =/date.timezone = \"America\/Bogota\"/g" ${php_config_file}

cat << EOF > ${xdebug_config_file}
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
EOF

# Install composer
echo "Installing Composer"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin
mv /usr/bin/composer.phar /usr/bin/composer

#Install Postgresql
echo "Installing PostgreSQL"
apt-get -y install postgresql postgresql-contrib
echo "ALTER USER postgres with password 'postgres';" | sudo -u postgres psql
pgsql_version=$(psql -V | egrep -o '[0-9]{1,}\.[0-9]{1,}')
pgsql_config_file="/etc/postgresql/$pgsql_version/main/pg_hba.conf"
sed -i "s/local   all             postgres                                peer/local   all             postgres                                md5/g" ${pgsql_config_file}

# Restart Services
service postgresql restart
service apache2 restart
service redis-server restart
service beanstalkd restart

touch /var/lock/vagrant-provision


