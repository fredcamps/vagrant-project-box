#!/bin/bash

wget -O /tmp/gitlab_7.9.4-omnibus.1-1_amd64.deb https://downloads-packages.s3.amazonaws.com/ubuntu-14.04/gitlab_7.9.4-omnibus.1-1_amd64.deb
dpkg -i /tmp/gitlab_7.9.4-omnibus.1-1_amd64.deb || apt-get install -y -f 2> /dev/null
gitlab-ctl reconfigure
adduser --disabled-login --gecos 'Git' git 2> /dev/null
