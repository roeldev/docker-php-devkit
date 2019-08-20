#!/bin/sh
set -e

phpExec="/project/vendor/bin/$1"
if [ -e "${phpExec}" ]
then
    shift
    php "${phpExec}" "$@"
else
    exec "$@"
fi
