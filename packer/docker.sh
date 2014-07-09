#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y curl
curl https://get.docker.io/gpg | apt-key add -
echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y lxc-docker

echo 'DOCKER_OPTS="-r=false"' > /etc/default/docker
cp /opt/packer/upstart.conf /etc/init/proxxy.conf

reboot
sleep 60
