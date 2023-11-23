#!/bin/bash

set -e # エラーがでたらスクリプトを終了する

echo -e "script---> \\n︙\\n︙\\n"
echo -e "whoami : {`whoami`}\\n"
echo -e "${CONTAINER_FRONT} is moving...\\n"
mv -f /tmp/${CONTAINER_FRONT}/* /tmp/${CONTAINER_FRONT}/.[^\.]* .
rm -f /tmp/${CONTAINER_FRONT}
echo -e "${CONTAINER_FRONT} is moved\\n"
echo -e "︙\\n︙\\n---> script done !! "

# # Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
