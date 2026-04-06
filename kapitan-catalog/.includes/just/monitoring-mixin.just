#!/usr/bin/env just --justfile

monitoring_tools_image := "docker.io/cznewt/monitoring-tools-amd64:latest"

[doc('Build monitoring mixin.')]
[group('monitoring')]
monitoring-mixin-build:
    @docker run -i --rm=true \
        -v $(pwd)/mixins:/source \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/source" \
        {{monitoring_tools_image}} monitoring-mixins-build

[doc('Initialize monitoring mixin.')]
[group('monitoring')]
monitoring-mixin-init:
    @docker run -i --rm=true \
        -v $(pwd)/mixins:/source \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/source" \
        {{monitoring_tools_image}} monitoring-mixins-init

[doc('Build monitoring mixin techdocs.')]
[group('monitoring')]
monitoring-mixin-techdocs-build:
    @docker run -i --rm=true \
        -v $(pwd):/source \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/source" \
        {{monitoring_tools_image}} monitoring-mixin-techdocs-build
