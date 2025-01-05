#!/bin/bash

set -ex;

VERSION=0.7.0
BUILD_ARCH=(armv7l aarch64 )

export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0

# Loop over architectures
for arch in "${BUILD_ARCH[@]}"
do
	echo "Build arch: $arch"

	SRC_IMAGE=toggledbits/reactor
	SRC_TAG=latest-$arch
	DST_IMAGE=$SRC_IMAGE-novol

	docker pull $SRC_IMAGE:$SRC_TAG

	./docker-copyedit.py \
	 FROM $SRC_IMAGE:$SRC_TAG INTO $DST_IMAGE:$SRC_TAG -vv -T /tmp REMOVE ALL VOLUMES 

	docker build -t darrylleaning/haosaddonrepo-$arch:$VERSION --build-arg BUILD_FROM=$DST_IMAGE:$SRC_TAG --build-arg BUILD_ARCH=$arch --build-arg BUILD_VERSION=$VERSION . 
	docker push darrylleaning/haosaddonrepo-$arch:$VERSION
	
done
