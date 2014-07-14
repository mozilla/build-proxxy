#!/usr/bin/env bash
# install Ansible Galaxy roles from Rolefile
ansible-galaxy install -r Rolefile -p ./roles --force
