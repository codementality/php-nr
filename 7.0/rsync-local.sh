#!/bin/bash

set -eo pipefail

#rsync files in /var/www/html to mounted directory /usr/local/data
if [ "$(ls -A /usr/local/data)" ] || [ $1 == 'rsync-local' ]; then
    rsync -av --delete /var/www/html/ /usr/local/data --exclude '.idea/' --exclude '.git'
fi
