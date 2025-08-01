# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.22

# set version label
ARG BUILD_DATE
ARG VERSION
ARG APP_VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"
LABEL org.opencontainers.image.source="https://github.com/thespad/docker-kopia-server"
LABEL org.opencontainers.image.url="https://github.com/thespad/docker-kopia-server"
LABEL org.opencontainers.image.description="A fast and secure open-source backup/restore tool that allows you to create encrypted snapshots of your data and save the snapshots to remote or cloud storage of your choice, to network-attached storage or server, or locally on your machine."
LABEL org.opencontainers.image.authors="thespad"

ENV TERM="xterm-256color" \
  LC_ALL="C.UTF-8" \
  KOPIA_CONFIG_PATH=/config/config/repository.config \
  KOPIA_LOG_DIR=/config/logs \
  KOPIA_CACHE_DIRECTORY=/config/cache \
  RCLONE_CONFIG=/config/rclone/rclone.conf \
  KOPIA_PERSIST_CREDENTIALS_ON_CONNECT=false \
  KOPIA_CHECK_FOR_UPDATES=false \
  PATH="/app/kopia:$PATH"

RUN \
  echo "**** install packages ****" && \
  apk add  --no-cache \
    docker-cli \
    findutils \
    fuse \
    openssl \
    rclone \
    sqlite && \
  echo "**** install kopia ****" && \
  if [ -z ${APP_VERSION+x} ]; then \
    APP_VERSION=$(curl -s https://api.github.com/repos/kopia/kopia/releases/latest \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  mkdir -p /app/kopia && \
  curl -o \
    /tmp/kopia.tar.gz -L \
    "https://github.com/kopia/kopia/releases/download/${APP_VERSION}/kopia-${APP_VERSION#v}-linux-x64.tar.gz" && \
  tar xf \
    /tmp/kopia.tar.gz -C \
    /app/kopia --strip-components=1 && \
  printf "Version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  rm -rf \
    $HOME/.cache \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 51515

VOLUME /config
