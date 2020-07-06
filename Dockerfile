# Use 18.04
FROM ubuntu:bionic

WORKDIR /root

# required to silence debconf errors see https://github.com/phusion/baseimage-docker/issues/58
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# dependencies
RUN apt-get update && apt-get install -y \
  apt-utils \
  software-properties-common \ 
  gnupg \
  less

# get indy-cli
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88
RUN add-apt-repository "deb https://repo.sovrin.org/sdk/deb bionic stable"
RUN apt-get update && apt-get install -y \
  indy-cli

CMD [ "/bin/bash" ]
