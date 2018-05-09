#!/bin/sh

docker run -d -v `pwd`/misc/init.d:/etc/my_init.d -v `pwd`/data:/opt/zeronet -p 2222:22 -p 43110:43110 zeronet:0.3.0
