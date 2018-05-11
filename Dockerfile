FROM debian:jessie
LABEL maintainer="FluxoTI <lucasvs@outlook.com>"

RUN useradd --system asterisk

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq -y && \
    apt-get install -y --no-install-recommends \
            subversion \
            automake \
            aptitude \
            autoconf \
            gcc \
            make \
            binutils-dev \
            build-essential \
            ca-certificates \
            curl \
            libncurses5-dev \
            libpcap-dev \
            libpcre3 \
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
            python-dev \
            python-pip \
            python-mysqldb \
            git \
            wget && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/* && \
    pip install alembic

## Install sngrep
RUN git clone https://github.com/irontec/sngrep && \
    cd sngrep && \
    ./bootstrap.sh \
    ./configure && \
    make && \
    make install && \
    rm -rf sngrep

ENV ASTERISK_VERSION=15.4.0

COPY build-asterisk.sh /build-asterisk
RUN DEBIAN_FRONTEND=noninteractive /build-asterisk

CMD ["/usr/sbin/asterisk", "-f"]