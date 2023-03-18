# The New DevShop Dockerfile.
# See https://www.linuxserver.io/
# syntax=docker/dockerfile:1

FROM lsiobase/ubuntu:focal

# set version label
ARG BUILD_DATE
ARG VERSION
ARG DEVSHOP_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="DevShop"

ARG DEVSHOP_PLATFORM_REPOSITORY
ARG DEVSHOP_PLATFORM_PATH

# environment settings
ENV DEVSHOP_PLATFORM_REPOSITORY https://github.com/opendevshop/devshop.platform.git
ENV DEVSHOP_PLATFORM_PATH /app/devshop/platform
ENV DEVSHOP_PLATFORM_PREPARE_SCRIPT $DEVSHOP_PLATFORM_PATH/scripts/build/prepare-ubuntu2004.sh

# linuxserver
RUN echo Installing $DEVSHOP_VERSION from $DEVSHOP_PLATFORM_REPOSITORY

RUN \
    if [ -z ${DEVSHOP_VERSION+x} ]; then \
        DEVSHOP_VERSION=$(curl -sL 'https://raw.githubusercontent.com/opendevshop/devshop.platform/main/version.txt' \
    | head -n 1 | cut -d ' ' -f 1); \
    fi && \
    apt update && apt install git -y && \
    git clone $DEVSHOP_PLATFORM_REPOSITORY $DEVSHOP_PLATFORM_PATH && \
    cd $DEVSHOP_PLATFORM_PATH && \
    git status && \
    git checkout $DEVSHOP_VERSION && \
    sh $DEVSHOP_PLATFORM_PREPARE_SCRIPT && \
    ./scripts/ansible-galaxy-install.sh

COPY root/ /
    
VOLUME /config
