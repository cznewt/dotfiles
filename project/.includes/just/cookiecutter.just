#!/usr/bin/env just --justfile

docker_cmd := "docker run -it --rm=true --network host"
docker_compose_cmd := "docker compose"

[doc('Build and push production container image.')]
[group('docker container')]
publish-prod-image: build-prod-image push-prod-image

[doc('Build and push development container image.')]
[group('docker container')]
publish-dev-image: build-dev-image push-dev-image

[doc('Build all container images.')]
[group('docker container')]
build-all-images: build-prod-image build-dev-image

[doc('Build and push all container images.')]
[group('docker container')]
publish-all-images: publish-prod-image publish-dev-image

[doc('Locally build production container image.')]
[group('docker container')]
build-prod-image:
    @docker run -it --rm=true \
        -v $PWD/docker:/source \
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
        -v $PWD/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        -e IMAGE_NEW_TAG="latest" \
        docker.io/cznewt/docker-tools:latest docker-container-tag

[doc('Push production container image to registry.')]
[group('docker container')]
push-prod-image:
    @docker run -it --rm=true \
        -v $PWD/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_ARCHES=$IMAGE_ARCHES \
        -e REGISTRY_AUTH_CONFIG="$(cat ~/.docker/config.json)" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        docker.io/cznewt/docker-tools:latest docker-container-push
    @docker run -it --rm=true \
        -v $PWD/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_ARCHES=$IMAGE_ARCHES \
        -e REGISTRY_AUTH_CONFIG="$(cat ~/.docker/config.json)" \
        -e IMAGE_NAME="$IMAGE_NAME" \
        -e IMAGE_TAG="latest" \
        docker.io/cznewt/docker-tools:latest docker-container-push

[doc('Locally build development container image.')]
[group('docker container')]
build-dev-image:
    @docker run -it --rm=true \
        -v $PWD/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e SOURCE_FILE=$BUILD_FILE \
        -e BUILD_ARGS="--file /source/Dockerfile.dev --no-cache $BUILD_ARGS" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_NAME="$IMAGE_NAME-dev" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        docker.io/cznewt/docker-tools:latest docker-container-build
    @docker run -it --rm=true \
        -v $PWD/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_NAME="$IMAGE_NAME-dev" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        -e IMAGE_NEW_TAG="latest" \
        docker.io/cznewt/docker-tools:latest docker-container-tag

[doc('Push development container image to registry.')]
[group('docker container')]
push-dev-image:
    @docker run -it --rm=true \
        -v $PWD/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_ARCHES=$IMAGE_ARCHES \
        -e REGISTRY_AUTH_CONFIG="$(cat ~/.docker/config.json)" \
        -e IMAGE_NAME="$IMAGE_NAME-dev" \
        -e IMAGE_TAG="$IMAGE_TAG" \
        docker.io/cznewt/docker-tools:latest docker-container-push
    @docker run -it --rm=true \
        -v $PWD/docker:/source \
        -v /var/lib/containers:/var/lib/containers \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e SOURCE_PATH="/source" \
        -e REGISTRY_NAME="$REGISTRY_NAME" \
        -e IMAGE_ARCHES=$IMAGE_ARCHES \
        -e REGISTRY_AUTH_CONFIG="$(cat ~/.docker/config.json)" \
        -e IMAGE_NAME="$IMAGE_NAME-dev" \
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

[doc('Run Docker compose command.')]
[group('docker compose')]
run-compose-cmd *args:
    @{{docker_compose_cmd}} {{args}}

[doc('Shop Docker compose container status.')]
[group('docker compose')]
show-env-status:
    @{{docker_compose_cmd}} ps
