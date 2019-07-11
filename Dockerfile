FROM ubuntu:18.10

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y systemd
RUN apt-get install -y apt-utils
RUN apt-get install -y autoconf
RUN apt-get install -y gcc
RUN apt-get install -y libc6
RUN apt-get install -y make
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y apache2
RUN apt-get install -y php
RUN apt-get install -y libapache2-mod-php7.2
RUN apt-get install -y libgd-dev
RUN apt-get install -y ufw

RUN apt-get install -y libmcrypt-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y bc
RUN apt-get install -y gawk
RUN apt-get install -y dc
RUN apt-get install -y build-essential
RUN apt-get install -y snmp
RUN apt-get install -y libnet-snmp-perl
RUN apt-get install -y gettext

RUN apt-get install -y python

WORKDIR /tmp
RUN wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.3.tar.gz
RUN tar xzf nagioscore.tar.gz

WORKDIR /tmp/nagioscore-nagios-4.4.3/
RUN ./configure --with-httpd-conf=/etc/apache2/sites-enabled
RUN make all

RUN make install-groups-users
RUN usermod -a -G nagios www-data

RUN make install
RUN make install-daemoninit
RUN make install-commandmode
RUN make install-config

RUN make install-webconf
RUN a2enmod rewrite
RUN a2enmod cgi


RUN ufw allow Apache
RUN ufw reload

RUN htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin admin


# Nagios Plugins
WORKDIR /tmp
RUN wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
RUN tar zxf nagios-plugins.tar.gz

WORKDIR /tmp/nagios-plugins-release-2.2.1/
RUN ./tools/setup
RUN ./configure
RUN make
RUN make install

RUN touch /run/nagios.lock

ADD mattermost.py /usr/local/nagios/libexec/mattermost.py
ADD conf/commands.cfg /usr/local/nagios/etc/objects/commands.cfg
ADD conf/contacts.cfg /usr/local/nagios/etc/objects/contacts.cfg
ADD conf/localhost.cfg /usr/local/nagios/etc/objects/localhost.cfg

ADD docker-cmd.sh .
RUN chmod a+x docker-cmd.sh
CMD ./docker-cmd.sh

# RUN service apache2 start
# RUN service nagios start
