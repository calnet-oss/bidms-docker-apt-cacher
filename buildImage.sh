#!/bin/bash

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

function check_exit {
  error_code=$?
  if [ $error_code != 0 ]; then
    echo "ERROR: last command exited with an error code of $error_code"
    exit $error_code
  fi
}

if [ -f config.env ]; then
  . ./config.env || check_exit
else
  cat << EOF
Warning: There is no config.env file.  It is recommended you copy
config.env.template to config.env and edit it before running this, otherwise
the argument defaults in the Dockerfile will be used.
EOF
fi

if [ ! -z "$NETWORK" ]; then
  echo "NETWORK=$NETWORK"
  ARGS+="--network $NETWORK "
fi

if [ ! -z "$APT_PROXY_URL" ]; then
  ARGS+="--build-arg APT_PROXY_URL=$APT_PROXY_URL "
elif [ -e $HOME/.aptproxy ]; then
  apt_proxy_url=$(cat $HOME/.aptproxy)
  ARGS+="--build-arg APT_PROXY_URL=$apt_proxy_url "
fi

if [ ! -z "$USE_SUDO" ]; then
  SUDO=sudo
fi

echo "Using ARGS: $ARGS"
$SUDO docker build $ARGS -t bidms/apt-cacher:latest imageFiles || check_exit
