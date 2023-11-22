FROM node:lts-alpine

RUN apk update \
    && apk add \
    git vim nano sudo bash curl shadow dumb-init

ARG APPNAME CONTAINER_FRONT LOCALUNAME LOCALUID LOCALGID
ENV LOCALUNAME=${LOCALUNAME} APPNAME=${APPNAME}

WORKDIR ${APPNAME}

RUN <<EOF
    usermod -u 2000 node && groupmod -g 2000 node
    useradd -s /bin/bash -u ${LOCALUID} -m ${LOCALUNAME}
    usermod -u ${LOCALUID} node && groupmod -g 2000 node
EOF
# -s /bin/bash  :ユーザーのデフォルトシェルを /bin/bash に設定
# -m            :ユーザーホームディレクトリ (/home/{USER}) を作成
# -aG           :ユーザーを指定したグループに追加

COPY --chown=${LOCALUNAME}:node --chmod=754 \
    ./${CONTAINER_FRONT}/entrypoint.sh /usr/bin/
COPY --chown=${LOCALUNAME}:node \
    ./.bashrc /home/${LOCALUNAME}/

ENTRYPOINT ["entrypoint.sh"]

# # --------------> The build image
# FROM node:latest AS build
# ARG APPNAME
# COPY ./${APPNAME} /usr/src/${APPNAME}
# WORKDIR /usr/src/${APPNAME}

# COPY ./${CONTAINER_FRONT}/node-entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/node-entrypoint.sh
# RUN chmod +x /usr/bin/node-entrypoint.sh
# RUN --mount=type=secret,mode=0644,id=npmrc,target=/usr/src/${APPNAME}/.npmrc npm init

# # npm ci or init&ci

# # RUN --mount=type=secret,mode=0644,id=npmrc,target=/usr/src/${APPNAME}/.npmrc npm ci --only=development

# # --------------> The development image
# FROM node:lts-alpine

# ARG APPNAME CONTAINER_FRONT
# # ARG LOCALUID LOCALUNAME LOCALGID LOCALGNAME 

# RUN apk update \
#     && apk add --no-cache libstdc++ dumb-init \
#     git vim nano sudo bash curl shadow

# # ENV NODE_ENV production
# ENV NODE_ENV development

# USER node
# COPY ./.bashrc /home/node/

# WORKDIR /usr/src/${APPNAME}
# COPY --chown=node:node --from=build /usr/src/${APPNAME}/node_modules /usr/src/${APPNAME}/node_modules
# COPY --chown=node:node . /usr/src/${APPNAME}

# COPY ./${CONTAINER_FRONT}/node-entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/node-entrypoint.sh
# ENTRYPOINT ["node-entrypoint.sh"]
# # CMD ["dumb-init", "node", "server.js"]