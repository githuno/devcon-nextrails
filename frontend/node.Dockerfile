# --------------> The build image
FROM node:latest AS build
ARG APPNAME
WORKDIR /usr/src/${APPNAME}
COPY package*.json /usr/src/${APPNAME}/
RUN --mount=type=secret,mode=0644,id=npmrc,target=/usr/src/${APPNAME}/.npmrc npm ci --only=production

# --------------> The production image
FROM node:lts-alpine

ARG APPNAME LOCALUID LOCALUNAME LOCALGID LOCALGNAME CONTAINER_FRONT

RUN apk update \
    && apk add --no-cache libstdc++ dumb-init \
    git vim nano sudo bash curl shadow

ENV NODE_ENV production

USER node
COPY ./.bashrc /home/node/

WORKDIR /usr/src/${APPNAME}
COPY --chown=node:node --from=build /usr/src/${APPNAME}/node_modules /usr/src/${APPNAME}/node_modules
COPY --chown=node:node . /usr/src/${APPNAME}

COPY ./${CONTAINER_FRONT}/node-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/node-entrypoint.sh
ENTRYPOINT ["node-entrypoint.sh"]
# CMD ["dumb-init", "node", "server.js"]