#!/bin/sh
ZHOME='/opt/zeronet'
exec /usr/bin/python $ZHOME/zeronet/zeronet.py --config_file $ZHOME/zeronet.conf
