FROM node:24-bookworm-slim AS node
FROM ubuntu:24.04
COPY --from=node /usr/local/ /usr/local/
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates curl git python3 libgmp10 libtinfo6 make g++ \
       dpkg-dev rpm tar gzip xz-utils zip unzip \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /repo
