#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y git make pbuilder python-mock python-configobj python-support cdbs
git clone --branch v3.4 https://github.com/BrightcoveOS/Diamond.git /opt/diamond
pushd /opt/diamond
  make builddeb
  dpkg -i build/diamond_*.deb
popd
cp /opt/packer/diamond.conf /etc/diamond/diamond.conf
chmod 600 /etc/diamond/diamond.conf
chown diamond:root /etc/diamond/diamond.conf
# no need to start the service - it will autostart on first boot
