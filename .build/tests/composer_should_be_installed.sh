#!/bin/sh
set -e

result=$( docker run $1 composer --version --no-ansi )
if [ ${result} != 'Composer' ]
then
    echo 'Composer is not properly installed'
    exit 1
fi
