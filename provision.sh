#!/usr/bin/bash
sudo apt-get update
sudo apt-get install -y vim nginx python-dev python-pip
sudo ln -sf /opt/proxxy/nginx.conf /etc/nginx/sites-enabled/default
sudo service nginx restart
