#!/usr/bin/env bash

MYSQL_VERSION="5.6"

export DEBIAN_FRONTEND=noninteractive
apt-get install -y "mysql-server-$MYSQL_VERSION" "mysql-client-$MYSQL_VERSION" 2> /dev/null || apt-get install -f -y 2> /dev/null
sed -i 's/bind-address/bind-address = 0.0.0.0/g' /etc/mysql/my.cnf
sed -i 's/key_buffer/key_buffer_size/g' /etc/mysql/my.cnf
service mysql restart
mysql -u root -e "CREATE DATABASE redmine CHARACTER SET utf8;"
mysql -u root -e "CREATE USER 'redmine'@'%' IDENTIFIED BY 'redmine';"
mysql -u root -e "GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'%';"
