#!/bin/bash

set -eo pipefail

#rsync files in mounted directory /usr/local/data to /var/www/html
if [ "$(ls -A /usr/local/data)" ] || [ $1 == 'rsync-app' ]; then
    rsync -av --delete /usr/local/data/ /var/www/html --exclude '.idea/' --exclude '.git'
fi
