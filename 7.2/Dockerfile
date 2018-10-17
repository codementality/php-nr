FROM php:7.2.11-fpm
\
MAINTAINER "Lisa Ridley, lisa@codementality.com"
\
# install the PHP extensions we need
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    apt-utils \
    autoconf \
    curl \
    gcc \
    sqlite3 \
    libsqlite3-dev \
    firebird-dev \
    libgmp-dev \
    libssl-dev \
    libbz2-dev \
    libc-dev \
    libtidy-dev \
    libedit-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libpng-dev \
    libxml2-dev \
    libldb-dev \
    libldap2-dev \
    make \
    mariadb-client \
    libpq-dev \
    pkg-config \
    unzip \
    zip \
    && pecl install redis-4.0.1 \
    && pecl install memcached-3.0.4 \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure bz2 --with-bz2 \
    && docker-php-ext-configure ldap --with-ldap=/usr \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install bcmath calendar dom exif \
    && CFLAGS="-I/usr/src/php" docker-php-ext-install xmlreader \
    && docker-php-ext-install ftp gettext gmp hash interbase intl json mbstring mysqli opcache pcntl \
    && docker-php-ext-install pdo_firebird pdo pdo_mysql pdo_sqlite \
    && docker-php-ext-install phar posix readline \
    && docker-php-ext-install session shmop simplexml soap sockets \
    && docker-php-ext-install sysvmsg sysvsem \
    && docker-php-ext-install sysvshm tidy tokenizer wddx xml \
    && docker-php-ext-install xmlrpc xmlwriter zip \
# set recommended PHP.ini settings
  # see https://secure.php.net/manual/en/opcache.installation.php
  && { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
	echo 'opcache.revalidate_freq=60'; \
	echo 'opcache.fast_shutdown=1'; \
	echo 'opcache.enable_cli=1'; \
  } > /usr/local/etc/php/conf.d/opcache-recommended.ini \
  && { \
    echo ';sendmail (do not remove)'; \
    echo ';sendmail_path'; \
    echo 'date.timezone = "UTC"'; \
    echo 'post_max_size = 20M'; \
    echo 'memory_limit = 192M'; \
  } > /usr/local/etc/php/conf.d/php.ini \
\
# Install Mailhog Sendmail support:
    && apt-get install -yq git golang-go \
    && mkdir -p /opt/go \
    && export GOPATH=/opt/go \
    && go get github.com/mailhog/mhsendmail \
# Clean up
    && apt-get auto-remove \
    && apt-get clean \
#install xdebug
  && mkdir -p ~/downloads \
  && wget -O ~/downloads/xdebug-2.6.1.tgz http://xdebug.org/files/xdebug-2.6.1.tgz \
  && cd ~/downloads \
  && tar -xvzf xdebug-2.6.1.tgz \
  && cd xdebug-2.4.0 \
  && phpize \
  && ./configure \
  && make \
  && make install \
  && cd .. \
  && rm -Rf xdebug-2.6.1 \
  && rm xdebug-2.6.1.tgz
COPY ./ini/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

# Register the COMPOSER_HOME environment variable
# Add global binary directory to PATH and make sure to re-export it
# Allow Composer to be run as root
# Composer version
ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_VERSION 1.7.2
#
# Setup the Composer installer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
 # Install Composer
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && rm -rf /tmp/composer-setup.php \
 # Install Prestissimo plugin for Composer -- allows for parallel processing of packages during install / update
    && composer global require "hirak/prestissimo:^0.3" \
    && chown -Rf www-data:www-data /composer \
    && mkdir /var/www/docroot \
    && chown -Rf www-data:www-data /var/www \
## Changes ownership of /usr/local/etc to www-data:www-data
  && chown -Rf www-data:www-data /usr/local/etc \
  && chown -Rf www-data:www-data /var/www \
  && chown -Rf www-data:www-data /composer \
## sets up /usr/local/data directory for mounting a native volume
  && mkdir /usr/local/data
\
WORKDIR /var/www/html
\
COPY docker-entrypoint.sh /usr/local/bin/
COPY rsync-app.sh /usr/local/bin/rsync-app
COPY rsync-local.sh /usr/local/bin/rsync-local
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh \
    && chmod a+x /usr/local/bin/rsync-app \
    && chmod a+x /usr/local/bin/rsync-local
\
USER www-data
\
ENTRYPOINT ["docker-entrypoint.sh"]
\
CMD ["php-fpm"]
