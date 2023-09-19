# Asterisk

Dockerfile to build [Asterisk](https://github.com/asterisk/asterisk) 18.19.0 with PJSIP Realtime.

### Includes
 - Pjproject-bundled
 - asterisk sounds EN (ULAW ALAW G722 G729 GSM SLN16)
 - Codec g729 (http://asterisk.hosting.lv/bin/codec_g729-ast150-gcc4-glibc-x86_64-core2.so)


# How To use
```yml
FROM ghcr.io/lucasvs/docker-asterisk:18.19.0-v1

# copy default configuration files from asterisk github repository
COPY --from=daemon-builder /go/bin/daemon /usr/bin/
COPY entrypoint.sh scripts/* /usr/bin/
COPY internal/conf/* /etc/asterisk/
COPY internal/contrib/ /usr/share/asterisk/contrib/
COPY internal/odbc/* /etc/
COPY internal/sounds/* /var/lib/asterisk/sounds/en/

CMD ["asterisk"]
```
