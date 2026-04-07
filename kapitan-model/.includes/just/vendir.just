#!/usr/bin/env just --justfile

[doc('Sync single catalog component.')]
[group('vendir')]
vendir-component-sync COMPONENT:
    @docker run --rm=true \
        -v $SSH_AUTH_SOCK:/ssh-agent \
        -v $(pwd):/source \
        -e VENDIR_FILE=".includes/vendir/vendir.{{ COMPONENT }}.yml" \
        -e VENDIR_LOCK_FILE=".includes/vendir/vendir.{{ COMPONENT }}.lock.yml" \
        -e SOURCE_PATH="/source" \
        docker.io/cznewt/backstage-tools:latest vendir-sync

[doc('Sync monitoring components used in the catalog.')]
[group('vendir')]
vendir-monitoring-sync:
    @docker run --rm=true \
        -v $SSH_AUTH_SOCK:/ssh-agent \
        -v $(pwd)/config/monitoring:/source \
        -e SOURCE_PATH="/source" \
        docker.io/cznewt/backstage-tools:latest vendir-sync
