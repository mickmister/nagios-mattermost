./configure --with-httpd-conf=/etc/apache2/sites-enabled
make all

make install-groups-users
usermod -a -G nagios www-data

make install
make install-daemoninit
make install-commandmode
make install-config

make install-webconf
a2enmod rewrite
a2enmod cgi

ufw allow Apache
ufw reload

htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin admin

# Nagios Plugins
cd /tmp
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
tar zxf nagios-plugins.tar.gz

cd /tmp/nagios-plugins-release-2.2.1/
./tools/setup
./configure
make
make install
