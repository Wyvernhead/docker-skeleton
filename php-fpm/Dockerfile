ARG PHP_VERSION=8.2
FROM php:${PHP_VERSION}-fpm

ARG UID=1000
ARG GID=1000

ENV UID=$UID
ENV GID=$GID

RUN groupadd -g $GID php
RUN useradd -rm -s /bin/bash -g php -u $UID -m php

RUN set -xe; \
    apt-get update -yqq \
    && pecl channel-update pecl.php.net \
    && apt-get install -yqq apt-utils zlib1g-dev g++ git libicu-dev libzip-dev zip unzip libpq-dev libxml2-dev

RUN set -xe; \
    docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install intl opcache pdo pdo_pgsql pgsql mysqli pdo_mysql xml zip soap sockets \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && if [ ${PHP_VERSION} = "7.3" ] || [ ${PHP_VERSION} = "7.4" ] || [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
               docker-php-ext-configure zip; \
             else \
               docker-php-ext-configure zip --with-libzip; \
             fi \
    && pecl install -o -f redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-configure pcntl --enable-pcntl \
    && docker-php-ext-install pcntl

COPY ./php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini

ARG DEBUG_MODE=${DEBUG_MODE:-false}
RUN if [ $DEBUG_MODE = true ]; then \
    pecl install xdebug && docker-php-ext-enable xdebug \
    && sed -i -e 's/opcache.enable=1/opcache.enable=0/' /usr/local/etc/php/conf.d/opcache.ini \
    ;fi

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

USER php

RUN mkdir "/home/php/bin"

WORKDIR /var/www

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/home/php/bin --filename=composer

RUN touch /home/php/.bashrc
RUN echo 'export PATH="/home/php/bin:$PATH"' >> /home/php/.bashrc

RUN mkdir "/home/php/log"
RUN touch "/home/php/log/fpm-php.www.log"

EXPOSE 9000
