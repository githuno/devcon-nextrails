FROM node:lts-alpine

ARG APPNAME CONTAINER_FRONT LOCALUID LOCALUNAME LOCALGID LOCALGNAME 

RUN apk update && apk --no-cache add \
    git vim nano sudo bash curl shadow dumb-init

# ENV NODE_ENV production
WORKDIR /tmp/${CONTAINER_FRONT}
COPY ./${APPNAME}/${CONTAINER_FRONT}/* /${APPNAME}/.env ./

RUN <<EOF
    usermod -u 2000 node
    groupmod -g 2000 node
    groupadd --gid ${LOCALGID} ${LOCALGNAME}
    useradd -s /bin/bash -u ${LOCALUID} -g ${LOCALGID} -m ${LOCALUNAME}
    usermod -aG ${LOCALGNAME},node ${LOCALUNAME}
    if [ ! -e "next.config.js" ]; then
        env CI=true npx create-next-app . --ts --eslint --tailwind --src-dir --app --import-alias "@/*"
    fi
    chown -R ${LOCALUID}:${LOCALGID} /tmp/${CONTAINER_FRONT}
EOF
# -s /bin/bash  :ユーザーのデフォルトシェルを /bin/bash に設定
# -m            :ユーザーホームディレクトリ (/home/{USER}) を作成
# -aG           :ユーザーを指定したグループに追加
COPY --chown=${LOCALUNAME}:${LOCALUNAME} \
    ./.devcontainer/.bashrc /home/${LOCALUNAME}/
COPY --chown=${LOCALUNAME}:${LOCALUNAME} --chmod=764 \
    ./.devcontainer/${CONTAINER_FRONT}/entrypoint.sh /usr/bin/

USER ${LOCALUNAME}
WORKDIR /${CONTAINER_FRONT}
