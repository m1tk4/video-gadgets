#
#   This Dockerfile is only used in the build process on Github
#

FROM rockylinux/rockylinux:8

ENV container=docker
ENV HOMEDIR=/home/build

RUN \
    dnf -y install rpm-build; \
    mkdir $HOMEDIR

# Ensure the termination happens on container stop, cgroup, starting init
WORKDIR $HOMEDIR
CMD ["make"]
