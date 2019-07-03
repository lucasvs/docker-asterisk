FROM debian:jessie
LABEL maintainer="FluxoTI <lucasvs@outlook.com>"

RUN useradd --system asterisk

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "Package: *" >> /etc/apt/preferences.d/testing && \
    echo "Pin: release a=testing" >> /etc/apt/preferences.d/testing && \
    echo "Pin-Priority: 100" >> /etc/apt/preferences.d/testing && \
    echo "deb http://ftp.us.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update -qq -y && \
    apt-get install -y -t testing --no-install-recommends \
            subversion \
            automake \
            aptitude \
            autoconf \
            binutils-dev \
            build-essential \
            ca-certificates \
            curl \
            libcurl4-openssl-dev \
            libedit-dev \
            libgsm1-dev \
            libjansson-dev \
            libogg-dev \
            libpopt-dev \
            libresample1-dev \
            libspandsp-dev \
            libspeex-dev \
            libspeexdsp-dev \
            libsqlite3-dev \
            libsrtp0-dev \
            libssl-dev \
            libvorbis-dev \
            libxml2-dev \
            libxslt1-dev \
            portaudio19-dev \
            python-pip \
            unixodbc-dev \
            uuid \
            uuid-dev \
            xmlstarlet \
            unixodbc \
            unixodbc-dev \
            libmyodbc \
	    python-setuptools \
            python-dev \
            python-pip \
            python-mysqldb \
            git \
            wget && \
    apt-get purge -y --auto-remove && \
    pip install alembic

## Install sngrep
RUN echo 'deb http://packages.irontec.com/debian jessie main' >> /etc/apt/sources.list && \
    wget http://packages.irontec.com/public.key -q -O - | apt-key add - && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update -y && \
    apt-get install -y sngrep

RUN rm -rf /var/lib/apt/lists/*

ENV ASTERISK_VERSION=16.4.0

COPY build-asterisk.sh /build-asterisk
RUN DEBIAN_FRONTEND=noninteractive /build-asterisk

CMD ["/usr/sbin/asterisk", "-f"]
