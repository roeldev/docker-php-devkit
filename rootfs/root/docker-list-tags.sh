#!/bin/sh

echo $( wget -q https://registry.hub.docker.com/v1/repositories/php/tags -O - \
  | sed -e 's/[][]//g' -e 's/"//g' -e 's///g' \
  | tr '}'OD '\n' \
  | awk -F: '{print $3}' \
  | grep -E '\-cli\-alpine$'
)
