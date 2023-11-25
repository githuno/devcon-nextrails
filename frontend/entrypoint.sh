#!/bin/bash

set -e # エラーがでたらスクリプトを終了する
echo -e "script-------------> \\n︙\\n"
echo -e "whoami : {`whoami`}\\n"

# chown mounted volume❌権限なし
# chown ${LOCALUID}:${LOCALGID} /${CONTAINER_FRONT}

# マウントによる上書きを避けるために一度tmpに入れたリソースを、ここで戻す
if [ -e "/tmp/node_modules" ]; then
    echo -e "node_modules is copying...\\n"
    cp -rf /tmp/node_modules ./node_modules

    echo -e "/tmp/node_modules is removing\\n"
    rm -rf /tmp/node_modules
fi

echo -e "︙\\n-------------> script done !! "
# Then exec the container's main process (what's set as CMD in the Dockerfile).
# PID 1 をdumb-initに渡して切り替えるイメージ？（これを挟まないとコンテナが起動前に終了する）
exec "$@"