FROM silkeh/clang:latest
# FROM silkeh/clang:17

# The silkeh/clang image is based on debian:buster-slim

# Available: wget
# Not available: curl
# Needs apt-get update before any ... I see!

# An image, only with`apt-get update`: absolutely nothing else
RUN apt-get update && apt-get install -y apt-utils

# RUN apt-get update && apt-get install -y bash

# not:    pip install --user pipx && \
# do I need " --user" also in apt-get install pipx ?
# no need: pipx ensurepath
#no need?    export PATH=$PATH:/root/.local/bin && \
# unable to locate pipx: apt-get install -y pipx
# ok, then update
# debconf: delaying package configuration, since apt-utils is not installed

# Set the environment variable DEBIAN_FRONTEND to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# dev layer
RUN \
   apt-get install -y bash && \
   apt-get install -y curl && \
   :
# At least, later ones will be fast. But cannot apt-fast before that.
# Alternative: manually install apt-fast
# https://github.com/ilikenwf/apt-fast

# separate sudo layer, for easy enabling and disabling sudo?
# Also fixes the user issue by creating a user called `myuser`
RUN \
   apt-get install -y sudo && \
   useradd -m -s /bin/bash -G sudo myuser && \
   echo 'myuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
   :

# Python layer (reusable)
RUN \
   apt-get install -y pipx && \
   export PATH=$PATH:/root/.local/bin && \
   :

# Two problems: 1. It is root 2. We don't have $PATH at time of docker build
ENV PATH=$PATH:/root/.local/bin

RUN \
   pipx install conan && \
   :

# Command available: /root/.local/bin/conan

# bash (not this, but the CVE one)
# realpath
# go (for act)
# act: no

# Reset DEBIAN_FRONTEND environment variable
ENV DEBIAN_FRONTEND=dialog

#   # Build the Docker image
#   docker build -t neopiler_clang17_with_conan2 -f /home/ephemssss/neopiler/toolchain/dockering/conan_with_clang.Dockerfile .
#
#   # Run the Docker container
#   docker run -it neopiler_clang17_with_conan2
