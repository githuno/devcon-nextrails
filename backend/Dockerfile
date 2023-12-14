
# docker-compose.ymlからもらう変数
ARG APPNAME LOCALUID LOCALUNAME LOCALGID \
LOCALGNAME CONTAINER_BACK RUBY_VERSION

FROM ruby:${RUBY_VERSION}-alpine

# コンテナ内にも引き継ぐ変数
ENV ROOT=/${APPNAME} \
SERVICE=${CONTAINER_BACK}

RUN apk update && apk add \
    alpine-sdk build-base gcompat \
    sqlite-dev postgresql-dev postgresql-client mysql-client \
    tzdata \
    nodejs \
    git vim nano sudo bash curl shadow dumb-init
    
WORKDIR /${APPNAME}

# compose.ymlから見た相対位置(ただし親階層には遡れない)
COPY ./.bashrc \
    ./${CONTAINER_BACK}/config/database.yml \
    ./${CONTAINER_BACK}/config/.gitignore /tmp/

RUN <<EOT
    touch /tmp/Gemfile.lock
    touch /tmp/Gemfile
    cat << EOF > /tmp/Gemfile
        source "https://rubygems.org"
        gem "rails", "~> 7.0.4"
    EOF
    
    useradd --create-home -s /bin/bash ${LOCALUNAME}
    chown -R ${LOCALUNAME}:${LOCALGNAME} /${APPNAME}
    chown -R ${LOCALUNAME}:${LOCALGNAME} /usr/local/bundle/
EOT
    
USER ${LOCALUNAME}:${LOCALGNAME}
COPY --chmod=755 ./${CONTAINER_BACK}/entrypoint.sh /usr/bin/