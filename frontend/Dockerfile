# --------------> The build image
FROM node:latest AS builder
ARG APPNAME CONTAINER_FRONT
COPY ./${APPNAME}/${CONTAINER_FRONT} /build/${CONTAINER_FRONT}
WORKDIR /build/${CONTAINER_FRONT}

RUN <<EOT
    if [ ! -e next.config.js ]; then
        env CI=true npx create-next-app . \
            --ts --eslint --tailwind --src-dir --app --import-alias "@/*"
    fi
    npm ci
EOT

# --------------> The production image
FROM node:lts-alpine

ARG CONTAINER_FRONT LOCALUID LOCALUNAME LOCALGID LOCALGNAME

RUN apk update && apk --no-cache add \
    git vim nano sudo bash curl shadow dumb-init

COPY --chown=${LOCALUID}:${LOCALGID} --from=builder \
    /build/${CONTAINER_FRONT} /tmp/${CONTAINER_FRONT}

RUN <<EOT
    usermod -u 2000 node && groupmod -g 2000 node
    groupadd -o --gid ${LOCALGID} ${LOCALGNAME}
    useradd -o -s /bin/bash -u ${LOCALUID} -g ${LOCALGID} -m ${LOCALUNAME}
    usermod -aG ${LOCALGNAME},node ${LOCALUNAME}
    chown -R ${LOCALUID}:${LOCALGID} /tmp/${CONTAINER_FRONT}
EOT

COPY --chown=${LOCALUID}:${LOCALGID} ./.devcontainer/.bashrc /tmp/
# COPY --chown=${LOCALUID}:${LOCALGID} ./.devcontainer/.bashrc /home/${LOCALUNAME}/
COPY --chown=${LOCALUID}:${LOCALGID} --chmod=764 ./.devcontainer/${CONTAINER_FRONT}/entrypoint.sh /usr/bin/

USER ${LOCALUNAME}
WORKDIR /${CONTAINER_FRONT}