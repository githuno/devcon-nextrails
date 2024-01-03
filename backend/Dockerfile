ARG RUBY_VERSION
FROM ruby:${RUBY_VERSION}-alpine

# compose.ymlからもらう変数
# (※FROM後、つまりVERSIONと分割しないと引き取れない)
ARG APPNAME LOCALUID LOCALUNAME LOCALGID \
LOCALGNAME CONTAINER_BACK

# コンテナ内に引き継ぐ変数
ENV ROOT=/${APPNAME} \
SERVICE=${CONTAINER_BACK}

RUN apk update && apk add \
    alpine-sdk build-base gcompat \
    sqlite-dev postgresql-dev postgresql-client mysql-client \
    tzdata \
    nodejs \
    git vim nano sudo bash curl shadow dumb-init 

# Tailscale (for Alpine : https://github.com/mvisonneau/docker-tailscale/blob/main/Dockerfile)
ARG TARGETARCH VERSION=1.48.2
RUN apk add --no-cache iptables iproute2 ca-certificates bash \
  && apk add --no-cache --virtual=.install-deps curl tar \
  && curl -sL "https://pkgs.tailscale.com/stable/tailscale_${VERSION}_${TARGETARCH}.tgz" \
  | tar -zxf - -C /usr/local/bin --strip=1 tailscale_${VERSION}_${TARGETARCH}/tailscaled tailscale_${VERSION}_${TARGETARCH}/tailscale \
  && apk del .install-deps
    # && sudo tailscale up --authkey ${TAILSCALE_KEY}

# cockroachdb
RUN curl --create-dirs -o $HOME/.postgresql/root.crt \
    'https://cockroachlabs.cloud/clusters/37f989f0-20e5-4ff7-834b-9f3146527512/cert' \
    # ccloud
    && curl https://binaries.cockroachdb.com/ccloud/ccloud_linux-amd64_0.6.12.tar.gz | tar -xz && cp -i ccloud /usr/local/bin/
    
WORKDIR /${APPNAME}

# compose.ymlから見た相対位置(ただし親階層には遡れない)
COPY ./.bashrc \
    ./${CONTAINER_BACK}/config/database.yml \
    ./${CONTAINER_BACK}/config/.gitignore /tmp/

RUN <<EOT1
    touch /tmp/Gemfile.lock
    touch /tmp/Gemfile
    cat << EOT1 > /tmp/Gemfile
source "https://rubygems.org"
ruby "${RUBY_VERSION}"
gem "rails", "~> 7.0.4"
EOT1

RUN <<EOT2
    groupadd -o --gid ${LOCALGID} ${LOCALGNAME}
    useradd -o -s /bin/bash -u ${LOCALUID} -g ${LOCALGID} -m ${LOCALUNAME}
    chown -R ${LOCALUNAME}:${LOCALGNAME} /${APPNAME}
    chown -R ${LOCALUNAME}:${LOCALGNAME} /usr/local/
    chown -R ${LOCALUNAME}:${LOCALGNAME} /tmp/
EOT2
    
USER ${LOCALUNAME}
COPY --chmod=755 ./${CONTAINER_BACK}/entrypoint.sh /usr/bin/