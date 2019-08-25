# local.image (without tag)
IMAGE_NAME=roeldev/php-devkit
# local.container_name
CONTAINER_NAME=php-devkit
# local.build.args.PHP_VERSION
DEFAULT_PHP_VERSION=7.3
DEFAULT_RELEASE=experimental

it: build login

build:
	docker-compose build local

inspect:
	docker inspect ${IMAGE_NAME}:local

login:
	docker-compose run local bash

7.1:
	docker-compose build \
		--build-arg PHP_VERSION=7.1 \
		--force-rm --pull local
	docker tag \
		${IMAGE_NAME}:local \
		${IMAGE_NAME}:7.1-${DEFAULT_RELEASE}

7.2:
	docker-compose build \
		--build-arg PHP_VERSION=7.2 \
		--force-rm --pull local
	docker tag \
		${IMAGE_NAME}:local \
		${IMAGE_NAME}:7.2-${DEFAULT_RELEASE}

7.3:
	docker-compose build \
		--build-arg PHP_VERSION=7.3 \
		--force-rm --pull local
	docker tag \
		${IMAGE_NAME}:local \
		${IMAGE_NAME}:7.3-${DEFAULT_RELEASE}

7.4-rc:
	docker-compose build \
		--build-arg PHP_VERSION=7.4-rc \
		--build-arg INSTALL_XDEBUG=false \
		--force-rm --pull local
	docker tag \
		${IMAGE_NAME}:local \
		${IMAGE_NAME}:7.4-rc-${DEFAULT_RELEASE}

.PHONY it build inspect login 7.1 7.2 7.3 7.4-rc:
