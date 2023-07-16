FROM node:18-alpine

# "apk add"は"apt-get install"の簡易版（alpine用）
RUN apk update \
    && apk add \
    git vim nano sudo bash curl shadow dumb-init
    # https://qiita.com/bricolageart/items/a509594a5b4c349e90b7

ARG APP_PATH LOCALUNAME
WORKDIR ${APP_PATH}

# ユーザーを追加しておく
RUN useradd --create-home ${LOCALUNAME}

COPY ./.devcontainer/.bashrc /tmp/
COPY ./.devcontainer/frontend/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]