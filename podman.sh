#!/bin/bash

# Function: to start, stop and restart the application.
# Usage: $0 start|stop|restart application

if [[ "$#" -lt 1 ]]; then
    echo "Usage: podman.sh start|stop command"
    echo "$# parameters given."
    exit 1
fi

case "${1}" in
    start)
        podman machine start
        podman machine ssh  "sudo sed -i 's/#NTP=.*/NTP=0.fedora.pool.ntp.org 1.fedora.pool.ntp.org/g' /etc/systemd/timesyncd.conf"
        podman machine ssh 'uname -a ; date -u && uptime --pretty && exit' 2>/dev/null; echo ; date -u && podman --version
        podman start keycloak
        podman start prometheus
        podman start grafana
    ;;
    stop)
       podman machine stop
    ;;
esac