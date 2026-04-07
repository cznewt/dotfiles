#!/usr/bin/env just --justfile

[doc('Show complete Kapitan inventory rendered metadata.')]
[group('kapitan')]
kapitan-inventory-metadata-show:
    @docker run --rm=true \
        -v $(pwd):/source \
        -v $(pwd)/compiled:/build \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/build" \
        docker.io/cznewt/kapitan-tools:latest kapitan-inventory-metadata-show

[doc('Build complete Kapitan inventory using jsonnet.')]
[group('kapitan')]
kapitan-inventory-build:
    @docker run --rm=true \
        -v $(pwd):/source \
        -v $(pwd)/compiled:/build \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/build" \
        docker.io/cznewt/kapitan-tools:latest kapitan-inventory-build

[doc('Build specific Kapitan target using jsonnet.')]
[group('kapitan')]
kapitan-target-build TARGET:
    @docker run --rm=true \
        -v $(pwd):/source \
        -v $(pwd)/compiled:/build \
        -e SOURCE_PATH="/source" \
        -e BUILD_PATH="/build" \
        -e SOURCE_TARGET="{{TARGET}}" \
        docker.io/cznewt/kapitan-tools:latest kapitan-target-build

[doc('Apply Kapitan inventory target using kubectl.')]
[group('kube')]
kube-target-apply TARGET:
    @kubectl apply -f ./compiled/compiled/{{TARGET}}/manifests/

[doc('Create Kapitan inventory target using kubectl.')]
[group('kube')]
kube-target-create TARGET:
    @kubectl create -f ./compiled/compiled/{{TARGET}}/manifests/

[doc('Delete Kapitan inventory target using kubectl.')]
[group('kube')]
kube-target-delete TARGET:
    @kubectl delete -f ./compiled/compiled/{{TARGET}}/manifests/

[doc('Show diff of Kapitan inventory target using kubectl.')]
[group('kube')]
kube-target-diff TARGET:
    @kubectl diff -f ./compiled/compiled/{{TARGET}}/manifests/

[doc('Get Kapitan inventory deploy status using kubectl.')]
[group('kube')]
kube-target-status TARGET:
    @kubectl get deploy -n {{TARGET}}
