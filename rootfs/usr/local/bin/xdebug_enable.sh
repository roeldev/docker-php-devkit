#!/bin/sh
set -e

file=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
if [ -f ${file} ]
then
    sed -i -E \
        's/;zend_extension=(.*xdebug\.so)/zend_extension=\1/g' \
        ${file}
fi
