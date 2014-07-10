#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y git
git clone https://github.com/laggyluke/proxxy.git /opt/proxxy
cp /opt/packer/config.json /opt/proxxy/app/config.json
docker build --rm --tag laggyluke/proxxy /opt/proxxy
docker run --name proxxy --detach --publish=80:80 laggyluke/proxxy
