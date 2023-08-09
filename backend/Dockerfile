FROM ruby:3.1.2-alpine

# docker-compose.ymlからもらう変数
ARG APP_PATH LOCALUID LOCALUNAME LOCALGID LOCALGNAME CONTAINER2
# コンテナ内にも引き継ぐ変数
ENV ROOT=${APP_PATH}
ENV SERVICE=${CONTAINER2}

# docker-compose.ymlから見た相対位置(ただし親階層には遡れない)
COPY ./.bashrc \
    ./${CONTAINER2}/config/database.yml \
    ./${CONTAINER2}/config/.gitignore \
    ./${CONTAINER2}/config/Gemfile \
    ./${CONTAINER2}/config/Gemfile.lock /tmp/
COPY ./${CONTAINER2}/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

RUN apk update && \
    apk add \
    alpine-sdk \
    build-base \
    sqlite-dev \
    postgresql-dev \
    tzdata \
    nodejs \
    git vim nano sudo \
    gcompat shadow bash postgresql-client

WORKDIR ${APP_PATH}

# ユーザ切り替え
RUN useradd --create-home ${LOCALUNAME}
RUN chown -R ${LOCALUNAME}:${LOCALGNAME} ${APP_PATH}
RUN chown -R ${LOCALUNAME}:${LOCALGNAME} /usr/local/bundle/
USER ${LOCALUNAME}:${LOCALGNAME}

# ADD . ${ROOT}
ENTRYPOINT ["entrypoint.sh"]

# CMD ["rails", "server", "-e"]
# CMD ["rm", "-f", "${ROOT}/tmp/pids/server.pid"]