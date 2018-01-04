#
# Copyright (c) 2018, Regents of the University of California and
# contributors.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
FROM bidms/debian_base

ARG APT_PROXY_URL=
RUN if [ ! -z "$APT_PROXY_URL" ]; then echo "Acquire::http::Proxy \"$APT_PROXY_URL\";" > /etc/apt/apt.conf.d/00aptproxy; else echo "not using apt proxy"; fi

RUN set -x \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y apt-cacher-ng ca-certificates cron \
  && apt-get clean \
  && rm -rf /var/log/apt-cacher-ng \
  && ln -fs /v1/var/log/apt-cacher-ng /var/log/apt-cacher-ng \
  && rm -rf /var/lib/apt/lists/* /tmp/* /core /var/log/dpkg.log

# for TLS
RUN sed -i 's/# PassThroughPattern: \.\*/PassThroughPattern: .*/' \
  /etc/apt-cacher-ng/acng.conf

COPY etc/container/ /etc/container/
ENTRYPOINT ["/etc/container/apt-cacher-entrypoint.sh", "interactive"]

RUN mkdir /v1
VOLUME /v1

EXPOSE 3142

COPY etc/apt-cacher-ng/* /etc/apt-cacher-ng/
RUN if [ -e "/etc/apt-cacher-ng/zzz_override_security.conf" ]; then chown apt-cacher-ng:apt-cacher-ng /etc/apt-cacher-ng/zzz_override_security.conf; fi

RUN echo 'Acquire::http::Proxy "http://localhost:3142";' | tee /etc/apt/apt.conf.d/00aptproxy

RUN rm -f /core
