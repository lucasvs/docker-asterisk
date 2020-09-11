FROM debian:bullseye
LABEL maintainer="FluxoTI <lucasvs@outlook.com>"

RUN useradd --system asterisk

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq -y && apt-get upgrade -qq -y && \
    apt-get install -y --no-install-recommends \
            subversion \
            automake \
            aptitude \
            autoconf \
            binutils-dev \
            build-essential \
            ca-certificates \
            curl \
            cmake \
            libcurl4-openssl-dev \
            libedit-dev \
            libgsm1-dev \
            libjansson-dev \
            default-libmysqlclient-dev \
            libogg-dev \
            libpopt-dev \
            libresample1-dev \
            libspandsp-dev \
            libspeex-dev \
            libspeexdsp-dev \
            libsqlite3-dev \
            libssl-dev \
            libtool \
            libvorbis-dev \
            libxml2-dev \
            libxslt1-dev \
            portaudio19-dev \
            python3-dev \
            python3-pip \
            unixodbc-dev \
            uuid \
            uuid-dev \
            xmlstarlet \
            unixodbc \
            unixodbc-dev \
            python3-setuptools \
            gnupg2 \
            git \
            wget && \
    apt-get purge -y --auto-remove && \
    pip install alembic mysqlclient && \
    # install libsrtp
    git clone https://github.com/cisco/libsrtp.git && cd libsrtp && \
    ./configure --prefix=/usr --enable-openssl && make && make install && \
    cd .. && rm -r libsrtp

## Install sngrep
RUN echo 'deb http://packages.irontec.com/debian jessie main' >> /etc/apt/sources.list && \
    wget http://packages.irontec.com/public.key -q -O - | apt-key add - && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get update -y && \
    apt-get install -y sngrep

RUN rm -rf /var/lib/apt/lists/*

ENV ASTERISK_VERSION=17.7.0

COPY build-asterisk.sh /build-asterisk
RUN DEBIAN_FRONTEND=noninteractive /build-asterisk

# Install g729
RUN git clone https://github.com/BelledonneCommunications/bcg729.git && cd bcg729 && \
    cmake . && make && make install && cd .. && rm -r bcg729 && \
    git clone https://github.com/arkadijs/asterisk-g72x.git && cd asterisk-g72x && \
    ./autogen.sh && ./configure --with-bcg729 && make && make install && \
    cd .. && rm -r asterisk-g72x

CMD ["/usr/sbin/asterisk", "-f"]
