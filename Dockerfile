FROM alpine:3.6

LABEL maintainer="L3msh0@gmail.com"

ARG NMAP_VERSION="7.01"

RUN \
  apk add --upgrade --no-cache \
    ca-certificates libpcap libgcc libstdc++ libressl2.5-libcrypto libressl2.5-libssl libcap && \
  update-ca-certificates && \
  apk add --upgrade --no-cache --virtual .builddeps \
    libpcap-dev libressl-dev lua-dev linux-headers alpine-sdk && \
  wget https://nmap.org/dist/nmap-${NMAP_VERSION}.tar.bz2 -O /tmp/nmap.tar.bz2 && \
  tar -xjf /tmp/nmap.tar.bz2 -C /tmp && \
  cd /tmp/nmap* && \
  ./configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --mandir=/usr/share/man \
    --infodir=/usr/share/info \
    --without-zenmap \
    --without-nmap-update \
    --with-openssl=/usr/lib \
    --with-liblua=/usr/include && \
  make && \
  make install && \
  apk del --purge .builddeps && \
  rm -rf /tmp/nmap* && \
  adduser -DH nmap && \
  setcap cap_net_raw+ep /usr/bin/nmap

USER nmap
VOLUME /work
ENTRYPOINT ["/usr/bin/nmap", "--privileged"]
