#!/bin/sh

release="7.1"
image="roeldev/php-devkit:${release}-experimental"
phpVersion="$( docker run ${image} php -r "echo phpversion();" )"
xdebugVersion="$( docker run ${image} php -r "echo phpversion('xdebug');" )"
composerVersion="$( docker run ${image} composer --version --no-ansi | cut -d' ' -f 3 )"
badgeImg="https://images.microbadger.com/badges/image/${image}.svg"
badgeUrl="https://microbadger.com/images/${image}"

parts=(
    " | [${image}][docker-tags-url]"
    " | ${phpVersion}"
    " | ${xdebugVersion}"
    " | ${composerVersion}"
    " | [![${badgeImg}]](${badgeUrl})"
)

result="| $( IFS=' | '; echo "${parts[*]}" )"
echo "${result}"
