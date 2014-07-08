#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get install -y wget unzip grub gdisk kpartx ruby1.9.1
wget http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools-1.5.3.zip
sudo unzip ec2-ami-tools-1.5.3.zip -d /tmp/ec2-ami-tools
sudo mv /tmp/ec2-ami-tools/* /opt/ec2-ami-tools
sudo ln -sv /opt/ec2-ami-tools/bin/* /usr/local/bin/
rm ec2-ami-tools-1.5.3.zip
rm -rf /tmp/ec2-ami-tools

sudo mv /tmp/menu.lst /boot/grub/menu.lst
sudo chown root:root /boot/grub/menu.lst
sudo chmod 644 /boot/grub/menu.lst
