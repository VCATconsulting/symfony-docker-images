#!/bin/bash
set -e

# import .ssh files, if existing
if [[ -d "/tmp/.ssh" ]]; then
    cp -R /tmp/.ssh /root/.ssh

    chown -R root:root /root/.ssh
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/*
    chmod 640 /root/.ssh/*.pub

    if [[ -f "/root/.ssh/known_hosts" ]]; then
        chmod 640 /root/.ssh/known_hosts
    fi

    if [[ -f "/root/.ssh/config" ]]; then
        chmod 640 /root/.ssh/config
    fi
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"
