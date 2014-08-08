#!/usr/bin/env bash
set -e

# exit early if this script was already ran
test -f /tmp/ran-common.sh && exit 0
touch /tmp/ran-common.sh

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get upgrade -y
