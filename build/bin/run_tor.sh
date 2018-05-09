#!/bin/sh

if ! test -d /var/log/tor; then
  mkdir -p /var/log/tor;
  chown debian-tor:debian-tor /var/log/tor
fi

if ! test -d /var/run/tor; then
  mkdir -p /var/run/tor;
  chown debian-tor:debian-tor /var/run/tor
fi

exec /usr/bin/tor --defaults-torrc /usr/share/tor/tor-service-defaults-torrc -f /etc/tor/torrc --RunAsDaemon 0
