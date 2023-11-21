#!/bin/bash

# set -e # エラーがでたらスクリプトを終了する
echo -e "entry...\\n"

# オーナー変更
# groupmod --non-unique --gid 1001 node #  -> 結局、yarn devのたびにroot権限ファイルが生成されてしまう
# usermod --non-unique --uid 1001 --gid 1001 node
groupmod --non-unique --gid ${LOCALGID} ${LOCALGNAME}
usermod --non-unique --uid ${LOCALUID} --gid ${LOCALGID} ${LOCALUNAME}
chown -R ${LOCALUNAME}:${LOCALGNAME} ${APP_PATH}
# su - ${LOCALUNAME}
echo -e "owner changed !!\\n\\n"

# .bashrcがあるかチェック
if [ ! -e "~/.bashrc" ]; then
    cp -f /tmp/.bashrc ~/
    echo -e ".bashrc copied !\\n\\n"
fi

echo -e "entry is done.\\n"
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
