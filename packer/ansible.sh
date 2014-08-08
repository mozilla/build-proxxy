#!/usr/bin/env bash
set -e

# exit early if this script was already ran
test -f /tmp/ran-ansible.sh && exit 0
touch /tmp/ran-ansible.sh

export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible
