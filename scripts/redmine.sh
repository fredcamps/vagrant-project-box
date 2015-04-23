#!/usr/bin/env bash

USER="redmine"
HOME_PATH="/home/$USER"
REDMINE_PATH="$HOME_PATH/redmine"

function configure_mysql {
    apt-get -y install debconf-utils 2> /dev/null
    debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
    apt-get install -y mysql-server mysql-client 2> /dev/null || apt-get install -f -y 2> /dev/null
    sed -i 's/127.0.0.1/0.0.0.1/g' /etc/mysql/my.cnf
    sed -i 's/key_buffer /key_buffer_size /g' /etc/mysql/my.cnf
    service mysql restart
    mysql -u root -p root -e "CREATE DATABASE redmine CHARACTER SET utf8;"
    mysql -u root -p root -e "CREATE USER 'redmine'@'localhost' IDENTIFIED BY 'YOURPASSWORD';"
    mysql -u root -p root -e "GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'localhost';"
}

function install_redmine {
    adduser --disabled-login --gecos 'Redmine' redmine
    wget http://www.redmine.org/releases/redmine-3.0.1.tar.gz
    tar -zxvf "$PWD/redmine-3.0.1.tar.gz" -C "$HOME_PATH" ; mv "$HOME_PATH/redmine-3.0.1" "$REDMINE_PATH"
    cp /vagrant/database.yml "$REDMINE_PATH/config/database.yml"
    curl -Lo "$REDMINE_PATH/config/puma.rb" https://gist.githubusercontent.com/jbradach/6ee5842e5e2543d59adb/raw/

    gem install rails
    gem install rake
    gem install bundler
    gem install puma
    gem update

    mkdir -p "$REDMINE_PATH/tmp/pids $REDMINE_PATH/tmp/sockets $REDMINE_PATH/public/plugin_assets"
    chmod -R 755 "$REDMINE_PATH/files $REDMINE_PATH/log $REDMINE_PATH/tmp $REDMINE_PATH/public/plugin_assets"

    cd "$REDMINE_PATH"
    # bundle install --without development test

    rake generate_secret_token
    RAILS_ENV=production rake db:migrate
    RAILS_ENV=production rake redmine:load_default_data

    chown redmine:redmine -R "$REDMINE_PATH"

    cp /vagrant/readmine.rc /etc/init.d/redmine
    chmod +x /etc/init.d/redmine
    update-rc.d redmine defaults
    service redmine start
}


apt-get update
apt-get upgrade -y
apt-get install -y nginx
apt-get install -y autoconf git curl bison build-essential aptitude 2> /dev/null
apt-get install -y imagemagick libmagickwand-dev build-essential libmariadbclient-dev libssl-dev 2> /dev/null
apt-get install -y libreadline-dev libyaml-dev zlib1g-dev python-software-properties 2> /dev/null
apt-get install -y ruby-full

configure_mysql
install_redmine

cp /vagrant/redmine /etc/nginx/sites-available/redmine
sudo ln -sf /etc/nginx/sites-available/redmine /etc/nginx/sites-enabled/redmine
sudo service nginx restart
