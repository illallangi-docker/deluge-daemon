FROM docker.io/fedora:30

MAINTAINER Andrew Cole <andrew.cole@illallangi.com>

RUN dnf -y install deluge-daemon-1.3.15-12.fc30 which findutils nano; \
    dnf -y update; \
    dnf -y clean all

RUN python3 -m pip install https://github.com/illallangi/DelugeSlackr/archive/master.zip
RUN python3 -m pip install autotorrent

ENV PUID=1000 \
    PGID=1000

RUN groupadd -g $PGID -r    abc && \
    useradd  -u $PUID -r -g abc abc

COPY contrib/confd-0.16.0-linux-amd64 /usr/local/bin/confd
COPY contrib/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init
COPY contrib/gosu_1.12_amd64 /usr/local/bin/gosu
COPY entrypoint.sh /entrypoint.sh
COPY confd/ /etc/confd/

RUN chmod +x \
        /entrypoint.sh \
        /usr/local/bin/confd \
        /usr/local/bin/dumb-init \
        /usr/local/bin/gosu

VOLUME /config
VOLUME /data

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/entrypoint.sh"]

ARG VCS_REF
ARG VERSION
ARG BUILD_DATE
LABEL maintainer="Andrew Cole <andrew.cole@illallangi.com>" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.description="Deluge Daemn" \
      org.label-schema.name="DelugeDaemn" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="http://github.com/illallangi/DelugeDaemn" \
      org.label-schema.usage="https://github.com/illallangi/DelugeDaemn/blob/master/README.md" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/illallangi/DelugeDaemn" \
      org.label-schema.vendor="Illallangi Enterprises" \
      org.label-schema.version=$VERSION
