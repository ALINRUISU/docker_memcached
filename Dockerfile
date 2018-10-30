FROM ubuntu:18.10
MAINTAINER alinruisu@gmail.com

# Create user + groups 
RUN groupadd --system --gid 11211 memcache && useradd --system --gid memcache --uid 11211 memcache

# Define Package Versions
ENV MEMCACHED_VERSION     1.5.10-0ubuntu1
ENV LIBMEMCACHED_VERSION  1.0.18-4.2

# Install Package
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      memcached=${MEMCACHED_VERSION}* \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      libmemcached-tools=${MEMCACHED_VERSION}* \
 && sed 's/^-d/# -d/' -i /etc/memcached.conf \
 && rm -rf /var/lib/apt/lists/*

# Adding the Scripts 
COPY docker-entrypoint.sh /sbin/docker-entrypoint.sh
RUN chmod 755 /sbin/docker-entrypoint.sh

# User configuration
USER memcache

# Commandline options
ENTRYPOINT [ "/sbin/docker-entrypoint.sh" ]
CMD ["/usr/bin/memcached"]

# Explose the TCP Port only
EXPOSE 11211/tcp
