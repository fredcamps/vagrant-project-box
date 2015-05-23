#!/usr/bin/env bash

LOCALE_LANGUAGE="en_US"
LOCALE_CODESET="en_US.UTF-8"
TIMEZONE="America/Sao_Paulo"

locale-gen "$LOCALE_LANGUAGE $LOCALE_CODESET"
echo "$TIMEZONE" | tee /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata

apt-get update 2> /dev/null && apt-get upgrade -y 2> /dev/null
apt-get install autoconf \
    automake \
    git \
    curl \
    bison \
    build-essential \
    aptitude \
    zlib1g-dev \
    libssl-dev \
    libreadline6-dev \
    libyaml-dev \
    libcurl4-openssl-dev \
    libreadline-dev \
    libyaml-dev \
    python-software-properties \
    imagemagick \
    libmagickwand-dev \
    libmariadbclient-dev \
    debconf-utils \
    openssh-server \
    ca-certificates \
    nginx \
    ruby \
    ruby-dev \
    rubygems-integration \
    ruby-bundler 2> /dev/null
apt-get -f install -y 2> /dev/null
