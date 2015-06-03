FROM phusion/baseimage:0.9.16
MAINTAINER John Kirkham <jakirkham@gmail.com>

RUN useradd -m -s /bin/bash -g sudo user
USER user
WORKDIR /home/user

ADD gridengine /usr/share/gridengine
RUN /usr/share/gridengine/install_ge.sh
