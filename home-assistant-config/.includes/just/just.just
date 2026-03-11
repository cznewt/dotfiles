#!/usr/bin/env just --justfile

[doc('Sync project dependencies using vendir.')]
vendir-sync:
    @docker run --rm=true \
        -v $SSH_AUTH_SOCK:/ssh-agent \
        -v ${PWD}:/source \
        -e VENDIR_FILE="vendir.yml" \
        -e VENDIR_LOCK_FILE="vendir.lock.yml" \
        -e SOURCE_PATH="/source" \
        docker.io/cznewt/backstage-tools:latest vendir-sync
