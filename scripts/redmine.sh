#!/usr/bin/env bash
USER="redmine"
HOME_PATH="/home/$USER"
REDMINE_PATH="$HOME_PATH/redmine"
REDMINE_VERSION="3.0.2"
REDMINE_URL="http://www.redmine.org/releases/redmine-$REDMINE_VERSION.tar.gz"

function install_redmine
{
    # install deps
    gem install rails bundler ssl

    # download redmine
    wget -O "/tmp/redmine-$REDMINE_VERSION.tar.gz" "$REDMINE_URL"
    tar -zxvf "/tmp/redmine-$REDMINE_VERSION.tar.gz" -C "$HOME_PATH" ; mv "$HOME_PATH/redmine-$REDMINE_VERSION" "$REDMINE_PATH"

    cp /vagrant/redmine/database.yml "$REDMINE_PATH/config/database.yml"
    cp /vagrant/redmine/puma.rb "$REDMINE_PATH/config/puma.rb"
    cp /vagrant/redmine/configuration.yml "$REDMINE_PATH/config/configuration.yml"

    {
        echo "# Gemfile.local"
        echo "gem 'puma'"
    } > "$REDMINE_PATH/Gemfile.local"

    cd "$REDMINE_PATH"
    bundle install --without development test
    bundle exec rake generate_secret_token
    RAILS_ENV=production bundle exec rake db:migrate
    RAILS_ENV=production REDMINE_LANG=en bundle exec rake redmine:load_default_data

    mkdir -p "$REDMINE_PATH/tmp" "$REDMINE_PATH/tmp/sockets" "$REDMINE_PATH/tmp/pids" "$REDMINE_PATH/tmp/pdf"
    mkdir -p "$REDMINE_PATH/public/plugin_assets" "$REDMINE_PATH/files" "$REDMINE_PATH/log"
    chmod -R 755 "$REDMINE_PATH/files"
    chmod -R 755 "$REDMINE_PATH/log"
    chmod -R 755 "$REDMINE_PATH/tmp"
    chmod -R 755 "$REDMINE_PATH/public/plugin_assets"
    chown -R redmine:redmine "$REDMINE_PATH"

    cp /vagrant/redmine/redmine /etc/nginx/sites-available/redmine ; ln -sf /etc/nginx/sites-available/redmine /etc/nginx/sites-enabled/redmine
    cp /vagrant/redmine/redmine.rc /etc/init.d/redmine
    chmod +x /etc/init.d/redmine
    update-rc.d redmine defaults
}

adduser --disabled-login --gecos 'Redmine' redmine
install_redmine
service redmine start
service nginx restart
