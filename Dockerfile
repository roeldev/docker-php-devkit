ARG PHP_VERSION="7.3"
FROM php:${PHP_VERSION}-cli-alpine

ENV PS1="$(whoami)@$(hostname):$(pwd) \\$ " \
    PATH="/root/.composer/vendor/bin:$PATH" \
    COMPOSER_ALLOW_SUPERUSER=1 \
    PHP_EXTENSIONS=""

RUN set -x \
 # update already installed packages
 && apk upgrade --no-cache \
 && apk update --no-cache

# add composer install script
ADD https://raw.githubusercontent.com/roeldev/docker-php-cli/master/rootfs/usr/local/bin/install_composer.sh /install_composer.sh
RUN set -x \
 # install composer dependencies
 && apk add \
    --no-cache \
    --virtual composer-deps \
        git \
        unzip \
 # create composer symlink dir
 && mkdir /composer/ \
 && ln -s /composer /root/.composer \
 # install composer
 && chmod +x /install_composer.sh \
 && ./install_composer.sh \
 && rm /install_composer.sh

# add xdebug install script
COPY install_xdebug.sh /
ARG INSTALL_XDEBUG=true
RUN set -x \
 && chmod +x /install_xdebug.sh \
 # install xdebug (default = true)
 && if ${INSTALL_XDEBUG}; then ./install_xdebug.sh; fi \
 && rm /install_xdebug.sh

RUN set -x \
 && apk add \
     --no-cache \
         bash \
         coreutils \
         htop \
         nano \
         tzdata \
 && mkdir /project \
 # cleanup
 && rm -rf /tmp/* \
 # result
 && php -v \
 && composer --version --no-ansi

# add local files
COPY rootfs/ /

WORKDIR /project/
VOLUME ["/composer/"]
ENTRYPOINT ["/init.sh"]
