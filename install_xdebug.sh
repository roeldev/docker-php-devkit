#!/bin/sh

set -x

# install xdebug dependencies
apk add \
    --no-cache \
    --virtual phpize-deps \
        autoconf \
        g++ \
        make

# install xdebug
pecl install xdebug
docker-php-ext-enable xdebug

# clean up
apk del phpize-deps
