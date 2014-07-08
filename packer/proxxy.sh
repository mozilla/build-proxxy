#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
apt-get install -y git
git clone https://github.com/laggyluke/proxxy.git /opt/proxxy
docker build --rm --tag laggyluke/proxxy /opt/proxxy
docker run --name proxxy --detach --publish=80:80 laggyluke/proxxy
