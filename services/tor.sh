#!/bin/sh
# Run zeronet required tor service as the user 'debian-tor'
exec /sbin/setuser debian-tor /usr/bin/tor -f /etc/torrc >> /var/log/tor.log 2>&1