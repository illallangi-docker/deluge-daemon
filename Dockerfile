FROM docker.io/fedora:30

MAINTAINER Andrew Cole <andrew.cole@illallangi.com>

RUN yum -y install deluge-daemon-1.3.15-12.fc30 which; \
    yum -y update; \
    yum -y clean all

COPY contrib/confd-0.16.0-linux-amd64 /usr/local/bin/confd
COPY contrib/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init
COPY entrypoint.sh /entrypoint.sh
COPY confd/ /etc/confd/

RUN chmod +x \
        /entrypoint.sh \
        /usr/local/bin/confd \
        /usr/local/bin/dumb-init

VOLUME /config
VOLUME /data

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/entrypoint.sh"]