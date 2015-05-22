#!/usr/bin/env bash

LOCALE_LANGUAGE="en_US"
LOCALE_CODESET="en_US.UTF-8"
TIMEZONE="America/Sao_Paulo"

locale-gen "$LOCALE_LANGUAGE $LOCALE_CODESET"
echo "$TIMEZONE" | tee /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata


apt-get upgrade -y
apt-get install -y autoconf git curl bison build-essential aptitude 2> /dev/null
apt-get install -y zlib1g-dev libssl-dev libreadline6-dev libyaml-dev libcurl4-openssl-dev 2> /dev/null
apt-get install -y libreadline-dev libyaml-dev zlib1g-dev python-software-properties 2> /dev/null
apt-get install -y imagemagick libmagickwand-dev libmariadbclient-dev 2> /dev/null
apt-get install -y debconf-utils 2> /dev/null
apt-get install -y nginx 2> /dev/null
apt-get install -y ruby ruby-dev rubygems-integration ruby-bundler 2> /dev/null
