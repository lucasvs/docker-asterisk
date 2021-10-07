FROM debian:bullseye
LABEL maintainer="FluxoTI <lucasvs@outlook.com>"

RUN useradd --system asterisk

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -qq -y && apt upgrade -qq -y && \
    apt install -y --no-install-recommends \
            subversion \
            automake \
            aptitude \
            autoconf \
            binutils-dev \
            build-essential \
            ca-certificates \
            curl \
            cmake \
            default-libmysqlclient-dev \
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
            libsrtp2-1 \
            libsrtp2-dev \
            libssl-dev \
            libtool \
            libvorbis-dev \
            libxml2-dev \
            libxslt1-dev \
            mysql-common \
            gnupg \
            portaudio19-dev \
            python3-dev \
            python3-pip \
            unixodbc-dev \
            uuid \
            uuid-dev \
            xmlstarlet \
            unixodbc \
            unixodbc-dev \
            sngrep \
            python3-setuptools \
            git \
            wget && \
    apt purge -y --auto-remove && \
    pip install alembic mysqlclient && \
    rm -rf /var/lib/apt/lists/*

# install mysql odbc driver
RUN apt update -y && apt install -y odbcinst1debian2 && \
    wget -Omultiarch-support.deb http://ftp.br.debian.org/debian/pool/main/g/glibc/multiarch-support_2.28-10_amd64.deb && \
    dpkg -i multiarch-support.deb && rm multiarch-support.deb && \
    wget -Olibmysqlclient18.deb http://archive.ubuntu.com/ubuntu/pool/main/m/mysql-5.5/libmysqlclient18_5.5.35+dfsg-1ubuntu1_amd64.deb && \
    dpkg -i libmysqlclient18.deb && rm libmysqlclient18.deb && \
    wget -Olibmyodbc.deb http://ftp.br.debian.org/debian/pool/main/m/myodbc/libmyodbc_5.1.10-3_amd64.deb && \
    dpkg -i libmyodbc.deb && \
    rm -rf /var/lib/apt/lists/*

ENV ASTERISK_VERSION=18.7.0

COPY build-asterisk.sh /build-asterisk
RUN DEBIAN_FRONTEND=noninteractive /build-asterisk

# Install g729
RUN git clone https://github.com/BelledonneCommunications/bcg729.git && cd bcg729 && \
    cmake . && make && make install && cd .. && rm -r bcg729 && \
    git clone https://github.com/arkadijs/asterisk-g72x.git && cd asterisk-g72x && \
    ./autogen.sh && ./configure --with-bcg729 && make && make install && \
    cd .. && rm -r asterisk-g72x

CMD ["/usr/sbin/asterisk", "-f"]
