#!/usr/bin/env just --justfile

backstage_tools_image := "docker.io/cznewt/backstage-tools:latest"

[doc('Initialize backstage component metadata.')]
[group('backstage')]
backstage-component-init:
    @docker run -i --rm=true \
        -v $(pwd):/source \
        -e SOURCE_PATH="/source" \
        {{backstage_tools_image}} backstage-component-init

[doc('Synchronize component dependencies using vendir.')]
[group('vendir')]
vendir-sync:
    @docker run -i --rm=true \
        -v ${SSH_AUTH_SOCK}:/ssh-agent \
        -v $(pwd):/source \
        -e SOURCE_PATH="/source" \
        {{backstage_tools_image}} vendir-sync
    @sudo chown -R $(id -u):$(id -g) $(pwd)
