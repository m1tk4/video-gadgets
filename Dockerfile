FROM rockylinux/rockylinux:8

LABEL maintainer="Dimitri Tarassenko <mitka@mitka.us>"

ENV container=docker
ENV HOMEDIR=/home/build

RUN \
    dnf -y install rpm-build; \
    mkdir $HOMEDIR

# Ensure the termination happens on container stop, cgroup, starting init
WORKDIR $HOMEDIR
#VOLUME ["$HOMEDIR"]
CMD ["make"]
