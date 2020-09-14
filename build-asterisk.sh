#!/bin/bash
set -ex

mkdir -p /usr/src/asterisk
cd /usr/src/asterisk

# 1.5 jobs per core works out okay
: ${JOBS:=$(( $(nproc) + $(nproc) / 2 ))}

echo -e "\e[34m ---> Downloading Asterisk\e[0m"
curl -sL https://github.com/asterisk/asterisk/archive/${ASTERISK_VERSION}.tar.gz |
    tar --strip-components 1 -xz

echo -e "\e[34m ---> Patching PJSIP-pjproject to support external srtp\e[0m"
sed -i 's/without-external-srtp/with-external-srtp/g' third-party/pjproject/Makefile.rules

echo -e "\e[34m ---> Building Asterisk\e[0m"
./bootstrap.sh
./contrib/scripts/get_mp3_source.sh
./contrib/scripts/install_prereq install
./configure --with-pjproject-bundled --with-resample --with-srtp --with-jansson-bundled

make menuselect/menuselect menuselect-tree menuselect.makeopts
menuselect/menuselect --disable BUILD_NATIVE \
--enable BETTER_BACKTRACES  \
--enable codec_opus \
--enable func_odbc \
--enable res_odbc \
--enable res_srtp \
--enable res_pjsip \
--enable res_ari \
menuselect.makeopts

echo -e "\e[34m ---> Downloading Core Sounds\e[0m"
# download more sounds
for i in CORE-SOUNDS-EN; do
    for j in ULAW ALAW G722 G729 GSM SLN16; do
        menuselect/menuselect --enable $i-$j menuselect.makeopts
    done
done

echo -e "\e[34m ---> Installing Asterisk\e[0m"
make -j ${JOBS} all
make install
make install-headers
chown -R asterisk:asterisk /var/*/asterisk
chmod -R 750 /var/spool/asterisk
mkdir -p /etc/asterisk/

# copy default configs
make basic-pbx

# set runuser and rungroup
sed -i -E 's/^;(run)(user|group)/\1\2/' /etc/asterisk/asterisk.conf

rm -rf /usr/src/asterisk
