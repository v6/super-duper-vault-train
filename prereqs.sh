#!/usr/bin/env bash

sudo curl --silent -Lo /bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
sudo chmod +x /bin/jq

YUM=$(which yum 2>/dev/null)
APT_GET=$(which apt-get 2>/dev/null)

if [[ ! -z ${YUM} ]]; then
  sudo yum -y check-update
  sudo yum install -q -y unzip bind-utils ruby rubygems ntp
  sudo systemctl start ntpd.service
  sudo systemctl enable ntpd.service
elif [[ ! -z ${APT_GET} ]]; then
  sudo sh -c 'echo "\nUseDNS no" >> /etc/ssh/sshd_config'
  sudo service ssh restart
  sudo apt-get -qq -y update
  sudo apt-get install -qq -y unzip dnsutils ruby rubygems ntp
  sudo systemctl start ntp.service
  sudo systemctl enable ntp.service
else
  echo "Can't tell if rhel or ubuntu"
  exit 1;
fi

