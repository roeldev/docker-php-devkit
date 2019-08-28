ARG PHP_VERSION="7.3"
FROM php:${PHP_VERSION}-cli-alpine

ARG INSTALL_XDEBUG=true
ARG PHP_CLI_REPO=https://raw.githubusercontent.com/roeldev/docker-php-cli/master

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
        unzip

# add installer scripts
ADD ${PHP_CLI_REPO}/rootfs/usr/local/bin/install_composer.sh /tmp/
ADD ${PHP_CLI_REPO}/rootfs/usr/local/bin/install_devkit.sh /tmp/
ADD https://get.symfony.com/cli/installer /tmp/symfony_installer.sh
COPY install_xdebug.sh /tmp/

RUN set -x \
 && chmod -R +x /tmp/ \
 # install composer
 && /tmp/install_composer.sh \
 # install xdebug (default = true)
 && if ${INSTALL_XDEBUG}; then /tmp/install_xdebug.sh; fi \
 # install useful dev tools
 && /tmp/install_devkit.sh \
 && bash /tmp/symfony_installer.sh \
 # cleanup
 && rm -rf /tmp/*

# add local files
COPY rootfs/ /

RUN set -x \
 # make executable, otherwise we can't enter the running container
 # or call the scripts when building the docker image
 && chmod +x /init.sh \
 # show the result of our building efforts
 && php -v \
 && composer --version --no-ansi

WORKDIR /project/
VOLUME ["/composer/cache/", "/project/"]
ENTRYPOINT ["/init.sh"]
