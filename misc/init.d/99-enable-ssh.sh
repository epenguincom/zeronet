#!/bin/sh
rm -f /etc/service/sshd/down
ssh-keygen -P "" -t dsa -f /etc/ssh/ssh_host_dsa_key
ssh-keygen -P "" -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key
