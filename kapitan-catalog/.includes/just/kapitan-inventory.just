#!/usr/bin/env just --justfile

kapitan_tools_image := "docker.io/cznewt/kapitan-tools:latest"

[doc('Build complete Kapitan inventory using jsonnet.')]
[group('kapitan')]
kapitan-inventory-build:
    @docker run -i --rm=true \
        -v $(pwd):/source \
        -v $(pwd)/compiled:/build \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/build" \
        {{kapitan_tools_image}} kapitan-inventory-build
