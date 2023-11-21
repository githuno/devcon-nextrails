#!/bin/bash

set -e # エラーがでたらスクリプトを終了する
echo -e "entry...\\n"

# ビルド時にコンテナ内でスクリプト実行したいときに使う

echo -e "entry is done.\\n"
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
