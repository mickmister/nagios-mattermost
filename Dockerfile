FROM ubuntu:18.10

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y systemd apt-utils autoconf gcc libc6 make wget unzip apache2 php libapache2-mod-php7.2 libgd-dev ufw libmcrypt-dev libssl-dev bc gawk dc build-essential snmp libnet-snmp-perl gettext python

WORKDIR /tmp
RUN wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.3.tar.gz
RUN tar xzf nagioscore.tar.gz

WORKDIR /tmp/nagioscore-nagios-4.4.3/

ADD install-nagios.sh .
RUN chmod a+x install-nagios.sh
RUN ./install-nagios.sh

RUN touch /run/nagios.lock

ADD mattermost.py /usr/local/nagios/libexec/mattermost.py
ADD conf/commands.cfg /usr/local/nagios/etc/objects/commands-temp.cfg
ADD conf/contacts.cfg /usr/local/nagios/etc/objects/contacts.cfg
ADD conf/localhost.cfg /usr/local/nagios/etc/objects/localhost.cfg

ADD conf/ports.conf /etc/apache2/ports-temp.conf
ADD conf/000-default.conf /etc/apache2/sites-enabled/000-default-temp.conf

ADD docker-cmd.sh .
RUN chmod a+x docker-cmd.sh
CMD ./docker-cmd.sh
