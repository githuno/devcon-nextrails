FROM ruby:3.1.2-alpine

# docker-compose.ymlからもらう変数
ARG APP_PATH LOCALUID LOCALUNAME LOCALGID LOCALGNAME
# コンテナ内に引き継ぐ変数
ENV ROOT=${APP_PATH}
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

COPY ./.devcontainer/backend/app/database.yml \
    ./.devcontainer/.bashrc \
    ./.devcontainer/backend/app/Gemfile \
    ./.devcontainer/backend/app/Gemfile.lock /tmp/
COPY ./.devcontainer/backend/entrypoint.sh /usr/bin/
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