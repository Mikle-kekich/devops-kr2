#!/usr/bin/env bash
# Run on the server as root: sudo bash ~/kr2/deploy/kr2-publish.sh
set -euo pipefail

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/kr2.key \
  -out /etc/ssl/certs/kr2.crt \
  -subj "/CN=notes.devops.local" \
  -addext "subjectAltName=DNS:notes.devops.local"
chown root:root /etc/ssl/private/kr2.key /etc/ssl/certs/kr2.crt
chmod 600 /etc/ssl/private/kr2.key
chmod 644 /etc/ssl/certs/kr2.crt

install -m 644 -o root -g root /home/devops/kr2/deploy/kr2.nginx.conf /etc/nginx/sites-available/kr2
ln -sfn /etc/nginx/sites-available/kr2 /etc/nginx/sites-enabled/kr2

nginx -t
systemctl reload nginx
echo "kr2 published"
