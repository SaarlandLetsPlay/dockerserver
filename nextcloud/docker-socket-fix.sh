#!/bin/sh
# Fix docker.sock permissions so www-data can access it for AppAPI
if [ -S /var/run/docker.sock ]; then
    chmod 666 /var/run/docker.sock
fi
exec /entrypoint.sh "$@"
