#!/usr/bin/env just --justfile

[doc('Validate ESPHome configuration.')]
[group('home-assistant')]
esphome-config-validate CONFIG:
    @docker run --rm=true \
        -v ${PWD}/esphome:/config \
        docker.io/esphome/esphome config /config/{{CONFIG}}

[doc('Validate all ESPHome configurations.')]
[group('home-assistant')]
esphome-configs-validate:
    #!/usr/bin/env bash
    find esphome -maxdepth 1 -name '*.yaml' ! -name 'secrets.yaml' | while read -r f; do
        just esphome-config-validate "$(basename "$f")"
    done

[doc('Run local ESPHome dashboard.')]
[group('home-assistant')]
esphome-dashboard-run:
    @docker run -it --rm=true --network host \
        -v ${PWD}/esphome:/config \
        docker.io/esphome/esphome dashboard /config
