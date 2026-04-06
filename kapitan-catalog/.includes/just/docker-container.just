#!/usr/bin/env just --justfile

set dotenv-load

docker_tools_image := "docker.io/cznewt/docker-tools:latest"

[doc('Build and push container image.')]
[group('docker container')]
container-publish: container-build container-push

[doc('Locally build container image.')]
[group('docker container')]
container-build:
    @docker run --rm=true \
        -v $(pwd)/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e SOURCE_FILE="$BUILD_FILE" \
        -e BUILD_ARGS="$BUILD_ARGS" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_ARCHES="$IMAGE_ARCHES" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        {{docker_tools_image}} docker-container-build
    @docker run --rm=true \
        -v $(pwd)/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_ARCHES="$IMAGE_ARCHES" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        -e IMAGE_NEW_TAG="latest" \
        {{docker_tools_image}} docker-container-tag

[doc('Push container image to registry.')]
[group('docker container')]
container-push:
    @docker run --rm=true \
        -v $(pwd)/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_ARCHES="$IMAGE_ARCHES" \
        -e REGISTRY_AUTH_CONFIG="$(cat ~/.docker/config.json)" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        {{docker_tools_image}} docker-container-push
    @docker run --rm=true \
        -v $(pwd)/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_ARCHES="$IMAGE_ARCHES" \
        -e REGISTRY_AUTH_CONFIG="$(cat ~/.docker/config.json)" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="latest" \
        {{docker_tools_image}} docker-container-push

[doc('Run container image shell.')]
[group('docker container')]
container-exec:
    @docker run --rm=true -it "$REGISTRY_NAME/$IMAGE_NAME:latest" /bin/sh

[doc('Show container image version.')]
[group('docker container')]
container-version:
    @docker run --rm=true "$REGISTRY_NAME/$IMAGE_NAME:latest" version

[doc('Pull latest container image from registry.')]
[group('docker container')]
container-image-sync:
    @docker image pull "$REGISTRY_NAME/$IMAGE_NAME:latest"
