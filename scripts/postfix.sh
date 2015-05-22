#!/usr/bin/env bash
HOSTNAME="manager"

echo postfix postfix/mailname string $HOSTNAME | debconf-set-selections
echo postfix postfix/main_mailer_type string 'Internet Site' | debconf-set-selections

sudo apt-get install -y postfix
service postfix reload
