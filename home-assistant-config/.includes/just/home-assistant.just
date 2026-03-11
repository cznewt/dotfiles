#!/usr/bin/env just --justfile

[doc('Validate Home Assistant configuration.')]
[group('home-assistant')]
home-assistant-config-validate:
    @docker run -it --rm=true \
        -v ${PWD}:/config \
        ghcr.io/home-assistant/home-assistant:stable \
        python3 -m homeassistant --config /config --script check_config

[doc('Run local Home Assistant server.')]
[group('home-assistant')]
home-assistant-server-run:
    @docker run -it --rm=true --network host \
        -v ${PWD}:/config \
        -v /run/dbus:/run/dbus:ro \
        ghcr.io/home-assistant/home-assistant:stable
