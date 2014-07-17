#!/usr/bin/env bash
set -e
mkdir -p /opt/proxxy
mv /opt/packer/app /opt/proxxy/app
chmod +x /opt/proxxy/app/*.sh
docker build --rm --tag proxxy /opt/proxxy/app
docker run --name proxxy --detach --publish=80:80 proxxy
