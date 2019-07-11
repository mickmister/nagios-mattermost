ADD conf/ports.conf /etc/apache2/ports.conf
ADD conf/000-default.conf /etc/apache2/sites-enabled/000-default.conf

cat /etc/apache2/ports-temp.conf | sed "s/80/${PORT}/g" > /etc/apache2/ports.conf
cat /etc/apache2/sites-enabled/000-default-temp.conf | sed "s/80/${PORT}/g" > /etc/apache2/sites-enabled/000-default.conf

cat /usr/local/nagios/etc/objects/commands-temp.cfg | sed "s#MM_URL#${MM_URL}#g" | sed "s#MM_CHANNEL#${MM_CHANNEL}#g" > /usr/local/nagios/etc/objects/commands.cfg

service apache2 start
/usr/local/nagios/bin/nagios /usr/local/nagios/etc/nagios.cfg
