# Use 18.04
FROM ubuntu:bionic

WORKDIR /root

# replace sh with bash to be able to source the resource file
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y \
    apt-utils \
    apt-transport-https \
    build-essential \
    software-properties-common \ 
    gnupg \
    less \
    curl \
    git \
    libssl-dev && \
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

ENV NVM_DIR /usr/local/.nvm
ENV NODE_VERSION stable

# Install nvm
RUN git clone https://github.com/creationix/nvm.git $NVM_DIR && \
    cd $NVM_DIR && \
    git checkout `git describe --abbrev=0 --tags`

# Install default version of Node.js
RUN source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm install lts/boron && \
    nvm install lts/carbon && \
    nvm install lts/dubnium && \
    nvm install lts/erbium && \
    nvm alias default $NODE_VERSION && \
    nvm use default

# Add nvm.sh to .bashrc for startup...
RUN echo "source ${NVM_DIR}/nvm.sh" > $HOME/.bashrc && \
    source $HOME/.bashrc

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
