#!/usr/bin/env just --justfile

docker_cmd := "docker run -it --rm=true --network host"
docker_compose_cmd := "docker compose"

[doc('Build and push container image.')]
[group('docker container')]
publish-image: build-image push-image

[doc('Locally build container image.')]
[group('docker container')]
build-image:
    @docker run -it --rm=true \
        -v $CURRENT_DIR:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e SOURCE_FILE=$BUILD_FILE \
        -e BUILD_ARGS="--no-cache $BUILD_ARGS" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        docker.io/cznewt/docker-tools:latest docker-container-build
    @docker run -it --rm=true \
        -v $CURRENT_DIR:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        -e IMAGE_NEW_TAG="latest" \
        docker.io/cznewt/docker-tools:latest docker-container-tag

[doc('Push container image to registry.')]
[group('docker container')]
push-image:
    @docker run -it --rm=true \
        -v $CURRENT_DIR:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e REGISTRY_AUTH_CONFIG="$(cat ~/.docker/config.json)" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        docker.io/cznewt/docker-tools:latest docker-container-push
    @docker run -it --rm=true \
        -v $CURRENT_DIR:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e REGISTRY_AUTH_CONFIG="$(cat ~/.docker/config.json)" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="latest" \
        docker.io/cznewt/docker-tools:latest docker-container-push

[doc('Start Docker compose environment.')]
[group('docker compose')]
start-env:
    @echo "Starting up containers..."
    @{{docker_compose_cmd}} up -d --remove-orphans

[doc('Stop Docker compose environment.')]
[group('docker compose')]
stop-env:
    @echo "Stopping Docker compose environment..."
    @{{docker_compose_cmd}} down

[doc('Remove containers and their volumes.')]
[group('docker compose')]
clean-env *args:
    @echo "Removing containers and their volumes..."
    @{{docker_compose_cmd}} down -v {{ "{{args}}" }}

[doc('View Docker compose container logs.')]
[group('docker compose')]
view-logs *args:
    @{{docker_compose_cmd}} logs -f {{args}}

[doc('Shop Docker compose container status.')]
[group('docker compose')]
show-env-status:
    @{{docker_compose_cmd}} ps
