FROM node:18-alpine

# "apk add"は"apt-get install"の簡易版（alpine用）
RUN apk update \
    && apk add \
    git vim nano sudo bash curl shadow dumb-init
    # https://qiita.com/bricolageart/items/a509594a5b4c349e90b7

COPY ./.devcontainer/.bashrc /root/

ARG APP_PATH
WORKDIR ${APP_PATH}

