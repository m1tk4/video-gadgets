#
#   This Dockerfile is only used in the build process on Github
#

FROM ubuntu:20.04

ENV container=docker
ENV HOMEDIR=/home/build

RUN \
    mkdir $HOMEDIR

# Ensure the termination happens on container stop, cgroup, starting init
WORKDIR $HOMEDIR
CMD ["/usr/bin/bash"]
