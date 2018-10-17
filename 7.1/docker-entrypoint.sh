#!/bin/bash

set -eo pipefail

#set Sendmail designation
if [ ! -z "$PHP_USE_MAILHOG" ] && [ "$PHP_USE_MAILHOG" == "1" ]; then
    echo "Modifying sendmail path..."
     sed -i 's@^;sendmail_path.*@'"sendmail_path = /usr/sbin/ssmtp -t"'@'  /usr/local/etc/php/conf.d/php.ini
fi

if [ ! -z "$PHP_INSTALL_XDEBUG" ] && [ "$PHP_INSTALL_XDEBUG" == "1" ]; then
    echo "Installing xdebug extension..."
    cp /usr/local/etc/php/conf-available/xdebug.ini  /usr/local/etc/php/conf.d/xdebug.ini
fi

#rsync files in mounted directory to /var/www/html
#if [ "$(ls -A /usr/local/data)" ] || [ $1 == 'rsync-app' ]; then
#    rsync -a /usr/local/data/ /var/www/html
#fi

"/usr/local/bin/rsync-app"

# Set other startup commands here

exec php-fpm
