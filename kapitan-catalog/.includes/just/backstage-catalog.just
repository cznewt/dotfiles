#!/usr/bin/env just --justfile

backstage_tools_image := "docker.io/cznewt/backstage-tools:latest"
cookiecutter_tools_image := "registry.newt.cz/cookiecutter-tools:latest"

[doc('Initialize backstage catalog metadata.')]
[group('backstage')]
backstage-catalog-init:
    @docker run --rm=true \
        -v $(pwd):/source \
        -e SOURCE_PATH="/source" \
        {{backstage_tools_image}} backstage-catalog-init

[doc('Bootstrap a new backstage Kapitan component from cookiecutter template.')]
[group('backstage')]
backstage-kapitan-component-init:
    @docker run --rm=true \
        -v $(pwd):/build \
        -e BUILD_PATH="/build" \
        {{cookiecutter_tools_image}} backstage-kapitan-component-init
    @sudo chown -R $(id -u):$(id -g) $(pwd)

[doc('Synchronize catalog dependencies using vendir.')]
[group('vendir')]
vendir-sync:
    @docker run --rm=true \
        -v ${SSH_AUTH_SOCK}:/ssh-agent \
        -v $(pwd):/source \
        -e SOURCE_PATH="/source" \
        {{backstage_tools_image}} vendir-sync
    @sudo chown -R $(id -u):$(id -g) $(pwd)
