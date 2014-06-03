#!/usr/bin/env bash
if [ ! -f nginx.conf ]; then
  echo "ERROR: nginx.conf not found"
  exit 1
fi

echo "Starting nginx..."
nginx -c /proxxy/nginx.conf

echo "Tailing logs..."
tail -F /var/log/proxxy.log
