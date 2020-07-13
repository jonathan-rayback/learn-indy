# Use 18.04
FROM ubuntu:bionic as os

WORKDIR /root

# dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y \
    apt-utils \
    apt-transport-https \
    build-essential \
    software-properties-common \
    pkg-config \
    cmake \ 
    gnupg \
    less \
    curl \
    git \
    libssl-dev \
    libsqlite3-dev \
    libzmq3-dev \
    libncursesw5-dev \
    python3.7 && \
  rm -rf /var/lib/apt/lists/*

# get indy-cli, libindy, libnullpay, and libvcx
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88
RUN add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic stable"
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y \
    indy-cli \
    libindy \
    libnullpay \
    libvcx && \
  rm -rf /var/lib/apt/lists/*

# lets subdirectories mounted as separate volumes find the .git file
ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=1

# for nvm installation I borrowed from this Dockerfile:
# https://hub.docker.com/r/theseg/docker-ubuntu-nvm/dockerfile

# replace sh with bash to be able to source the resource file
# This is weird...
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV NVM_DIR /usr/local/.nvm
# need to use v8 to compile indy-sdk
ENV NODE_VERSION v8

# install nvm
RUN git clone https://github.com/creationix/nvm.git $NVM_DIR && \
    cd $NVM_DIR && \
    git checkout `git describe --abbrev=0 --tags`

# install default version of Node.js and npm
RUN source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION --latest-npm && \
    nvm install lts/boron --latest-npm && \
    nvm install lts/carbon --latest-npm && \
    nvm install lts/dubnium --latest-npm && \
    nvm install lts/erbium --latest-npm && \
    nvm alias default $NODE_VERSION && \
    nvm use default

# add nvm.sh to .bashrc for startup...
RUN echo "source ${NVM_DIR}/nvm.sh" > $HOME/.bashrc && \
    source $HOME/.bashrc

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules

# install node-gyp and LibIndy Node Wrapper
CMD npm install -g node-gyp && npm install
