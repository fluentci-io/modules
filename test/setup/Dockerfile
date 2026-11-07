FROM node:24-bookworm-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates curl debianutils erlang-base gzip tar unzip xz-utils zip \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /repo
