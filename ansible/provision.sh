#!/usr/bin/env bash
ENVIRONMENT=$1
shift
PLAYBOOK=$1
shift

if [ "$PLAYBOOK" == "" ]; then
  PLAYBOOK="all.yml"
fi

ansible-playbook -i ${ENVIRONMENT}.ini --vault-password-file=../.vaultpass $@ "$PLAYBOOK"
