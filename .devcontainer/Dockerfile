FROM almalinux/9-base

USER root

RUN mkdir /workspace

RUN yum install -y yum-utils && \
    yum -y install git mc rpm-build

COPY .bashrc /root/.bashrc



#ENV SHELL=/bin/bash

# Expose ports
#EXPOSE 4000