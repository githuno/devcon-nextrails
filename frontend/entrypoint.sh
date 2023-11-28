#!/bin/bash

set -e # エラーがでたらスクリプトを終了する
echo -e "script-------------> \\n︙\\n"
echo -e "whoami : {`whoami`}\\n"

# chown mounted volume❌権限なし
# chown ${LOCALUID}:${LOCALGID} /${CONTAINER_FRONT}

# マウントによる上書きを避けるために一度tmpに入れたリソースを、ここで戻す
if [ -e "/tmp/${CONTAINER_FRONT}" ]; then
    echo -e "/tmp/${CONTAINER_FRONT} is copying...\\n"
    cp -rf /tmp/${CONTAINER_FRONT}/* ./

    echo -e "/tmp/${CONTAINER_FRONT} is removing\\n"
    rm -rf /tmp/${CONTAINER_FRONT}
fi

echo -e "︙\\n-------------> script done !! "

# execはこのスクリプト(entrypoint.sh)のプロセスを"$@"（＝引数、つまりdumb-init）のプロセスに置き換える https://linuxcommand.net/exec/
exec "$@"