ARG PHP_VERSION="7.3"
FROM roeldev/php-composer:${PHP_VERSION}-v1.5

# expose environment variables
ENV COMPOSER_INSTALL="" \
    XDEBUG_ENABLED=true

ARG PHP_VERSION="7.3"
RUN set -x \
 # install composer
 && /usr/local/bin/install_xdebug.sh
