FROM docker.io/fedora:31

MAINTAINER Andrew Cole <andrew.cole@illallangi.com>

RUN yum -y install deluge-daemon which; \
    yum -y update; \
    yum -y clean all

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

VOLUME /config
ENTRYPOINT ["/entrypoint.sh"]