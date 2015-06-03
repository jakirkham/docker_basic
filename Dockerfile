FROM phusion/baseimage:0.9.16
MAINTAINER John Kirkham <jakirkham@gmail.com>


RUN echo "root:docker" | chpasswd

RUN apt-get update && apt-get install -y sudo && apt-get clean

RUN groupadd wheel && \
    useradd -m -s /bin/bash -g wheel user && \
    echo '%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD gridengine /usr/share/gridengine
RUN /usr/share/gridengine/install_ge.sh

ENV SGE_CONFIG_DIR=/usr/share/gridengine \
    SGE_ROOT=/var/lib/gridengine \
    SGE_CELL=default \
    DRMAA_LIBRARY_PATH=/usr/lib/libdrmaa.so.1.0

ADD supervisor /usr/share/supervisor
RUN mv /usr/share/supervisor/supervisord.conf /etc/supervisord.conf
RUN /usr/share/supervisor/install_supervisor.sh

ADD miniconda /usr/share/miniconda
RUN /usr/share/miniconda/install_miniconda.sh

ENV PATH=/opt/conda/bin:$PATH

ADD docker /usr/share/docker

USER user
WORKDIR /home/user

ENTRYPOINT [ "/usr/share/docker/docker_entrypoint.sh" ]
EXPOSE 10389 22
CMD ["/usr/bin/supervisord"]
