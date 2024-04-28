FROM        ubuntu:22.04
MAINTAINER  Wei Zhou <ustcweizhou@gmail.com>

ENV         DEBIAN_FRONTEND noninteractive

RUN         apt update -qq && \
            apt upgrade -y && \
            apt install -y curl iproute2 net-tools iputils-ping apt-transport-https tini openssh-server

RUN         echo "deb http://download.cloudstack.org/ubuntu jammy 4.19" > /etc/apt/sources.list.d/cloudstack.list && \
            curl -L http://download.cloudstack.org/release.asc -o /etc/apt/trusted.gpg.d/cloudstack.asc && \
            apt update -qq && \
            apt install -y cloudstack-management && \
            apt install -y cloudstack-usage

COPY        bin /usr/bin
COPY        entrypoint.sh /entrypoint.sh

EXPOSE      8080 8250 8096 22

ENTRYPOINT  ["tini", "--", "/entrypoint.sh"]
