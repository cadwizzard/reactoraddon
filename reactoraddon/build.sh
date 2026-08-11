#!/bin/bash

set -ex

VERSION=0.96.1
BUILD_ARCH=(aarch64)

export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0

for arch in "${BUILD_ARCH[@]}"; do
    echo "Build HA architecture: $arch"

    SRC_IMAGE=toggledbits/reactor
    DST_IMAGE="${SRC_IMAGE}-novol"

    case "$arch" in
        aarch64)
            SRC_TAG=latest-arm64
            ;;
        *)
            echo "Unsupported architecture: $arch" >&2
            exit 1
            ;;
    esac

    docker pull "${SRC_IMAGE}:${SRC_TAG}"

    ./docker-copyedit.py \
        FROM "${SRC_IMAGE}:${SRC_TAG}" \
        INTO "${DST_IMAGE}:${SRC_TAG}" \
        -vv -T /tmp REMOVE ALL VOLUMES

    docker build \
        -t "darrylleaning/haosaddonrepo-${arch}:${VERSION}" \
        --build-arg "BUILD_FROM=${DST_IMAGE}:${SRC_TAG}" \
        --build-arg "BUILD_ARCH=${arch}" \
        --build-arg "BUILD_VERSION=${VERSION}" \
        .

    docker push "darrylleaning/haosaddonrepo-${arch}:${VERSION}"
done
