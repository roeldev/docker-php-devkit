# https://hub.docker.com/_/php
ARG PHP_VERSION="7.3"
FROM php:${PHP_VERSION}-cli-alpine

ARG INSTALL_XDEBUG=true

# expose environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd) \\$ " \
    PATH="/root/.composer/vendor/bin:/root/.symfony/bin:$PATH" \
    COMPOSER_ALLOW_SUPERUSER=1 \
    PHP_EXTENSIONS="" \
    COMPOSER_REQUIRE="" \
    XDEBUG="${INSTALL_XDEBUG}"

RUN set -x \
 # update already installed packages
 && apk upgrade --no-cache \
 && apk update --no-cache \
 && apk add \
    --no-cache \
        bash \
        coreutils \
        git \
        gzip \
        htop \
        nano \
        tzdata \
        unzip \
        # ext-zip dependency
        libzip-dev \
 && docker-php-ext-install zip

# add installer scripts
ADD https://raw.githubusercontent.com/roeldev/docker-php-cli/master/rootfs/usr/local/bin/install_composer.sh /tmp/
ADD https://get.symfony.com/cli/installer /tmp/symfony_installer.sh

# add local files
COPY rootfs/ /

RUN set -x \
 # make executable, otherwise we can't enter the running container
  # or call the scripts when building the docker image
 && chmod +x /init.sh \
 && chmod -R +x /tmp/ \
 # install composer
 && /tmp/install_composer.sh \
 # install xdebug (default = true)
 && if ${INSTALL_XDEBUG}; then /tmp/install_xdebug.sh; fi \
 # install symfony installer
 && bash /tmp/symfony_installer.sh \
 # cleanup
 && rm -rf /tmp/*

RUN set -x \
 # install useful common dev tools
 && composer global require \
    --no-ansi \
    --no-cache \
        laravel/installer \
        phploc/phploc \
        phpstan/phpstan-shim \
        roeldev/phpcs-ruleset \
        squizlabs/php_codesniffer \
 # add custom phpcs standard to available default standards
 && ln -s \
    /composer/vendor/roeldev/phpcs-ruleset \
    /composer/vendor/squizlabs/php_codesniffer/src/Standards/roeldev \
 # show the result of our building efforts
 && php -v \
 && composer --version --no-ansi

WORKDIR /project/
VOLUME ["/composer/cache/", "/project/"]
ENTRYPOINT ["/init.sh"]
