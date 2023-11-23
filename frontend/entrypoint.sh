#!/bin/bash

# set -e # エラーがでたらスクリプトを終了する

echo -e "script---> \\n︙\\n︙\\n︙\\n"
echo -e "whoami : {`whoami`}\\n"
echo -e "pwd & ls/ & ls: `pwd && ls -la / && ls -la`\\n"
echo -e "ls /home/ryo: `ls /home/ryo/`\\n"
echo -e "ls /usr/bin: `ls /usr/bin/`\\n"
echo
cat /etc/passwd
cat /etc/group

# 例: 必要なプロセスのPIDが100と101の場合
KEEP_PIDS="1"

# 不要なプロセス（PIDが1ではない）を検索してキルする
for pid in $(ps -A -o pid | tail -n +2); do
    if [ $pid -ne 1 ] && ! echo "$KEEP_PIDS" | grep -qw "$pid"; then
        kill -9 "$pid"
    fi
	echo "check point ...kill $pid "
done

echo -e "︙\\n︙\\n︙\\n---> script done !! "
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
