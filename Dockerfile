FROM phusion/baseimage:0.10.1
MAINTAINER epenguincom <ken@epenguin.com>

LABEL maintainer="Kenneth Zhao <ken@epenguin.com>" \
      name="zeronet and tor under runit" \
      description="Run zeronet and tor as services." \
      vendor="Penguin Digital, Ltd" \
      version="0.3.0"

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

ENV HOME /root
WORKDIR /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Install pip and tor package
RUN /sbin/install_clean tor python python-pip python-setuptools python-wheel

# Add config and run scripts
# RUN mkdir -p /tmp/build
ADD ./build /tmp/build

# Setup tor service
RUN cat /tmp/build/etc/torrc >> /etc/tor/torrc \
&&  cp -f /tmp/build/bin/run_tor.sh /usr/local/bin/run_tor.sh \
&&  mkdir -p /etc/service/tor \
&&  cp -f /tmp/build/services/tor.sh /etc/service/tor/run \
&&  chmod +x /etc/service/tor/run

# Preparing python environment for zeronet
RUN pip install gevent msgpack \
&&  apt-get remove -y python-pip python-setuptools python-wheel \
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

# Setup zeronet service 
RUN cp -f /tmp/build/bin/run_zeronet.sh /usr/local/bin/run_zeronet.sh \
&&  mkdir -p /etc/service/zeronet \
&&  cp -f /tmp/build/services/zeronet.sh /etc/service/zeronet/run \
&&  chmod +x /etc/service/zeronet/run

# Clean up the build dir
RUN rm -rf /tmp/build

#Expose ports
#EXPOSE 43110 43110

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
