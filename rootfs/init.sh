#!/bin/sh
set -e

if ! ${XDEBUG:-true}
then
    /usr/local/bin/xdebug_disable.sh
fi

phpExec="/project/vendor/bin/$1"
if [ -e "${phpExec}" ]
then
    shift
    php "${phpExec}" "$@"
else
    exec "$@"
fi
