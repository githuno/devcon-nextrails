FROM node:18-alpine

# "apk add"は"apt-get install"の簡易版（alpine用）
RUN apk update \
    && apk add \
    git vim nano sudo bash curl shadow dumb-init
    # https://qiita.com/bricolageart/items/a509594a5b4c349e90b7

ARG APP_PATH LOCALUID LOCALUNAME LOCALGID LOCALGNAME CONTAINER1
WORKDIR ${APP_PATH}

# ユーザーを追加して、環境変数をコンテナ内に渡す
RUN useradd --create-home ${LOCALUNAME}
ENV LOCALUID=${LOCALUID}
ENV LOCALUNAME=${LOCALUNAME}
ENV LOCALGID=${LOCALGID}
ENV LOCALGNAME=${LOCALGNAME}
ENV APP_PATH=${APP_PATH}

# docker-compose.ymlから見た相対位置(ただし親階層には遡れない)
COPY ./.bashrc /tmp/
COPY ./${CONTAINER1}/entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["next-entrypoint.sh"]