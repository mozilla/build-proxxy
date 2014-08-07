#!/usr/bin/env bash
set -e
mkdir -p /opt/proxxy
mkdir -p /mnt/proxxy
mv /opt/packer/app /opt/proxxy/app

cp /opt/proxxy/app/sysctl.conf /etc/sysctl.d/60-proxxy.conf
service procps start

chmod +x /opt/proxxy/app/*.sh
docker build --rm --tag proxxy /opt/proxxy/app
docker run --name proxxy \
  --privileged \
  --detach \
  --publish=80:80 \
  --volume=/mnt/proxxy/cache:/var/cache/proxxy \
  --volume=/mnt/proxxy/logs:/var/log/proxxy \
  proxxy
docker stop proxxy
