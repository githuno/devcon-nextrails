#!/bin/bash

set -e # エラーがでたらスクリプトを終了する

echo -e "script-------------> \\n︙\\n"
echo -e "whoami : {`whoami`}\\n"
echo -e "NEXT : {${NEXT}}\\n"

# マウントによる上書きを避けるために一度tmpに入れたリソースを、ここで戻す
if [ -e "/tmp/${CONTAINER_FRONT}" ]; then
    echo -e "${CONTAINER_FRONT} is copying...\\n"
    cp -rf /tmp/${CONTAINER_FRONT}/* .

    echo -e "/tmp/${CONTAINER_FRONT} is removing\\n"
    rm -rf /tmp/${CONTAINER_FRONT}

    echo -e "npm installing\\n"
    npm ci
fi

echo -e "︙\\n-------------> script done !! "
# Then exec the container's main process (what's set as CMD in the Dockerfile).
# PID 1 をdumb-initに渡して切り替えるイメージ？（これを挟まないとコンテナが起動前に終了する）
exec "$@"
