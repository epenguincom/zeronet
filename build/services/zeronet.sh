#!/bin/sh
# Run zeronet service as the user 'zeronet'
ZHOME='/opt/zeronet'

# But first, we need to initialize the zeronet volume '/opt/zeronet'
if ! test -d $ZHOME/zeronet; then
  cp -r /root/ZeroNet-master $ZHOME/zeronet;
fi

if ! test -d $ZHOME/data; then
  mkdir -p $ZHOME/data;
  chown -R zeronet:zeronet $ZHOME/data;
fi

if ! test -d /var/log/zeronet; then
  mkdir -p /var/log/zeronet;
  chown -R zeronet:zeronet /var/log/zeronet
fi

if ! test -f $ZHOME/zeronet.conf; then
  cat > $ZHOME/zeronet.conf <<EOF
[global]
data_dir = $ZHOME/data
log_dir = /var/log/zeronet

tor = always
tor_controller = 127.0.0.1:9051
tor_proxy = 127.0.0.1:9050

ui_ip = 0.0.0.0
EOF
fi

chown -R zeronet:zeronet $ZHOME;

exec /sbin/setuser zeronet /usr/local/bin/run_zeronet.sh
