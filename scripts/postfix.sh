#!/usr/bin/env bash
HOSTNAME="manager"

echo postfix postfix/mailname string "${HOSTNAME}" | debconf-set-selections
echo postfix postfix/main_mailer_type string 'Internet Site' | debconf-set-selections

sudo apt-get install -y postfix mailutils libsasl2-2 libsasl2-modules
cp /vagrant/postfix/main.cf /etc/postfix/main.cf
cp /vagrant/postfix/sasl_passwd /etc/postfix/sasl_passwd
cp /vagrant/postfix/tls_per_site /etc/postfix/tls_per_site
chmod 400 /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
service postfix reload
