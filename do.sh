#!/bin/bash
set -e

build() {
    docker-compose build --force-rm --pull "php-devkit_$1"
}

build-all() {
    for i in $@; do
        build ${i}
    done
}

inspect() {
    docker inspect "roeldev/php-devkit:$1-local"
}

run() {
    version=$1
    shift

    docker-compose run "php-devkit_${version}" $@
}

login() {
    run $1 bash
}

display-help() {
    echo "Usage:"
    echo "  do PHP_VERSION ACTION"
    echo "  do PHP_VERSION -- COMMAND"
    echo ""
    echo "PHP versions:"
    echo "$( printf "  %s\n" "${supportedPhpVersions[@]}" )"
    echo ""
    echo "Actions:"
    echo "  build      Build Docker image"
    echo "  inspect    Inspect Docker image"
    echo "  login      Run bash on Docker container"
    echo "  --         Run the command via the Docker container"
    echo ""
}

supportedPhpVersions=('7.1' '7.2' '7.3' '7.4-rc')
if [[ ! " ${supportedPhpVersions[@]} " =~ " $1 " ]]; then
    display-help
    exit
fi

phpVersion=$1
callAction=$2
shift
shift

if [[ "${callAction}" == '' ]]
then
    build ${phpVersion}
    login ${phpVersion}
    exit
fi
if [[ "${callAction}" == '--' ]]
then
    run ${phpVersion} $@
    exit
fi

availableActions=('build' 'inspect' 'login')
if [[ " ${availableActions[@]} " =~ " ${callAction} " ]]; then
    ${callAction} ${phpVersion} $@
    exit
fi

display-help
