#!/bin/bash

set -e # エラーがでたらスクリプトを終了する

echo -e "script-------------> \\n︙\\n"
echo -e "whoami : {`whoami`}\\n"

echo -e "${CONTAINER_FRONT} is copying...\\n"
cp -rf /tmp/${CONTAINER_FRONT}/* .

echo -e "/tmp/${CONTAINER_FRONT} is removing\\n"
rm -rf /tmp/${CONTAINER_FRONT}

echo -e "npm installing\\n"
npm ci

echo -e "︙\\n-------------> script done !! "
# # Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
