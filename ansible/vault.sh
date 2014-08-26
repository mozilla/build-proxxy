#!/usr/bin/env bash
COMMAND=$1
ENVIRONMENT=$2

ansible-vault $COMMAND --vault-password-file=../.vaultpass group_vars/$ENVIRONMENT
