# local.image (without tag)
IMAGE_NAME=roeldev/php-devkit
# local.container_name
CONTAINER_NAME=php-devkit
# local.build.args.PHP_VERSION
DEFAULT_PHP_VERSION=7.3

.PHONY it:
it: build login

.PHONY build:
build:
	docker-compose build local

.PHONY kill:
kill:
	docker rm ${CONTAINER_NAME}

.PHONY inspect:
inspect:
	docker inspect ${IMAGE_NAME}:local

.PHONY tag:
tag:
	docker tag ${IMAGE_NAME}:local ${IMAGE_NAME}:${DEFAULT_PHP_VERSION}-v1

.PHONY login:
login:
	docker-compose run local bash

.PHONY renew:
renew:
	docker pull php:${DEFAULT_PHP_VERSION}--cli-alpine
