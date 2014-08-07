#!/usr/bin/env bash
set -e

if [ ! -f nginx.conf ]; then
  echo "ERROR: nginx.conf not found"
  exit 1
fi

echo "Applying sysctl tweaks..."
service procps start

echo "Starting nginx..."
nginx -c /proxxy/nginx.conf

echo "Tailing logs..."
tail -F /var/log/proxxy/*.log
