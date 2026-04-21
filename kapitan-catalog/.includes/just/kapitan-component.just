#!/usr/bin/env just --justfile

kapitan_tools_image := "docker.io/cznewt/kapitan-tools:latest"
container_tools_image := "docker.io/cznewt/container-tools:latest"

[doc('Clean compiled Kapitan target output.')]
[group('kapitan')]
kapitan-target-clean:
    @docker run --rm=true \
        --user $(id -u):$(id -g) \
        -v $(pwd)/manifests/kapitan/compiled:/source \
        -e SOURCE_PATH="/source" \
        {{container_tools_image}} clean

[doc('Build single Kapitan target using jsonnet.')]
[group('kapitan')]
kapitan-target-build:
    @docker run --rm=true \
        --user $(id -u):$(id -g) \
        -v $(pwd)/manifests/kapitan:/source \
        -v $(pwd)/manifests/kapitan:/build \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/build" \
        {{kapitan_tools_image}} kapitan-target-build

[doc('Build complete Kapitan inventory using jsonnet.')]
[group('kapitan')]
kapitan-inventory-build:
    @docker run --rm=true \
        --user $(id -u):$(id -g) \
        -v $(pwd)/manifests/kapitan:/source \
        -v $(pwd)/manifests/kapitan:/build \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/build" \
        {{kapitan_tools_image}} kapitan-inventory-build

[doc('Fetch Kapitan jsonnet dependencies.')]
[group('kapitan')]
kapitan-dependency-fetch:
    @docker run --rm=true \
        --user $(id -u):$(id -g) \
        -v $(pwd)/manifests/kapitan:/source \
        -v $(pwd)/manifests/kapitan:/build \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/build" \
        {{kapitan_tools_image}} kapitan-dependency-fetch

[doc('Show complete Kapitan inventory rendered metadata.')]
[group('kapitan')]
kapitan-inventory-metadata-show:
    @docker run --rm=true \
        --user $(id -u):$(id -g) \
        -v $(pwd)/manifests/kapitan:/source \
        -v $(pwd)/manifests/kapitan:/build \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/build" \
        {{kapitan_tools_image}} kapitan-inventory-metadata-show
