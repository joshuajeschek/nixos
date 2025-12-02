#!/usr/bin/env bash

veil() {
  PIDFILE="/tmp/veil.pid"
  while true; do
    if [ -f "$PIDFILE" ]; then
      echo "󱡇"
    else
      echo "󱡆"
    fi
    sleep 1
  done
}

case "$1" in
  veil)
    veil
    ;;
  *)
    echo "Usage: $0 {veil}" >&2
    ;;
esac
