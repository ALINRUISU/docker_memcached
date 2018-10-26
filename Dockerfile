FROM ubuntu:18.10
MAINTAINER rsu@blizzard.com

RUN groupadd --system --gid 11211 memcache && useradd --system --gid memcache --uid 11211 memcache

ENV MEMCACHED_VERSION     1.5.10-0ubuntu1
ENV LIBMEMCACHED_VERSION  1.0.18-4.2

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      memcached=${MEMCACHED_VERSION}* \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      libmemcached-tools=${MEMCACHED_VERSION}* \
 && sed 's/^-d/# -d/' -i /etc/memcached.conf \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

USER memcache
EXPOSE 11211/tcp
ENTRYPOINT [ "executable" ]
CMD ["/usr/bin/memcached"]