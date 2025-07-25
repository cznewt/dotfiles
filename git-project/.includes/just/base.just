#!/usr/bin/env just --justfile

vendir_cmd := "docker run -it --rm=true --network host -v ${SSH_AUTH_SOCK}:/ssh-agent -v $CURRENT_DIR:/source -e SOURCE_PATH=/source docker.io/cznewt/backstage-tools:latest"

[doc('Show available just recipes.')]
default:
    @just --list

[doc('Synchronize includes using vendir.')]
[group('base')]
sync-includes:
    @{{vendir_cmd}} vendir-sync
    @sudo chown -R $(id -u):$(id -g) ./.includes
