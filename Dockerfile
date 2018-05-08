# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/baseimage:0.10.1
MAINTAINER epenguincom <ken@epenguin.com>

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

ENV HOME /root

WORKDIR /root

# RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install pip and tor package
RUN /sbin/install_clean tor python3-pip python3-setuptools python3-wheel

# Configure tor service for zeronet connection
RUN { \
    echo 'SOCKSPort 9050'; \
    echo 'ControlPort 9051'; \
    echo 'CookieAuthentication 1'; \
} >  /etc/torrc \
&& chown debian-tor:debian-tor /etc/torrc

# Add tor service schema for runit daemon
RUN mkdir -p /etc/service/tor
ADD ./services/tor.sh /etc/service/tor/run
RUN chmod +x /etc/service/tor/run

# Preparing python environment for zeronet
RUN pip3 install gevent msgpack \
&&  apt-get remove -y python3-pip python3-setuptools python3-wheel \
&&  apt-get autoremove -y

# Creating zeronet user/group
RUN useradd -r zeronet \
&&  usermod -aG debian-tor zeronet

# Add zeronet master source
ADD https://github.com/HelloZeroNet/ZeroNet/archive/master.tar.gz /tmp
RUN tar -C /root -xzf /tmp/master.tar.gz \
&&  chown -R zeronet:zeronet ZeroNet-master \
&&  mkdir -p /opt/zeronet

VOLUME  /opt/zeronet

# Add zeronet service schema for runit daemon
RUN mkdir -p /etc/service/zeronet
ADD ./services/zeronet.sh /etc/service/zeronet/run
RUN chmod +x /etc/service/zeronet/run

#Expose ports
EXPOSE 43110 43110

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
