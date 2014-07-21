#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y wget unzip grub gdisk kpartx ruby1.9.1
wget http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools-1.5.3.zip
unzip ec2-ami-tools-1.5.3.zip -d /tmp/ec2-ami-tools
mv /tmp/ec2-ami-tools/* /opt/ec2-ami-tools
ln -sv /opt/ec2-ami-tools/bin/* /usr/local/bin/
rm ec2-ami-tools-1.5.3.zip
rm -rf /tmp/ec2-ami-tools

mv /opt/packer/menu.lst /boot/grub/menu.lst
chown root:root /boot/grub/menu.lst
chmod 644 /boot/grub/menu.lst

export KERNEL_RELEASE=`uname -r`
export KERNEL_LINE=`cat /proc/cmdline | sed 's/[^ ]* //'`
sed -i.bak "s/%KERNEL_RELEASE%/${KERNEL_RELEASE}/" /boot/grub/menu.lst
sed -i.bak "s/%KERNEL_LINE%/${KERNEL_LINE}/" /boot/grub/menu.lst
