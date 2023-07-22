#!/bin/bash

# set -e # エラーがでたらスクリプトを終了する

echo "エントリー"

# nextがcreate済みかをチェック
if [ ! -e "next.config.js" ]; then
    echo "check point 1..."
    env CI=true npx create-next-app . --ts --eslint --tailwind --src-dir --app --import-alias "@/*"
    echo 'next-app created!!'
    # env CI=false

    # 参考「create-next-appで訊かれていること」： https://zenn.dev/ikkik/articles/51d97ff70bd0da
    # 参考「non-interactive」：https://nextjs.org/docs/pages/api-reference/create-next-app#non-interactive
        #   Ok to proceed? (y)
        # ✔ Would you like to use TypeScript with this project? … No / <u>**Yes**</u>
        # ✔ Would you like to use ESLint with this project? … No / <u>**Yes**</u>
        # ✔ Would you like to use Tailwind CSS with this project? … No / <u>**Yes**</u>
        # ✔ Would you like to use `src/` directory with this project? … <u>No</u> / <u>**Yes**</u>
                # `デフォルトでは、pagesディレクトリはプロジェクトのルートに存在する必要があるのですが、
                # これを src/pages に変更できるオプションです。デフォルトではNoになっているが、
                # もしかしたらソースコードはsrcディレクトリの中にまとめてしまった方が、
                # ルートがスッキリしてわかりやすくなるかもしれません。`
        # ✔ Use App Router (recommended)? … No / <u>**Yes**</u>
        # ✔ Would you like to customize the default import alias? … <u>**No**</u> / Yes
        # Creating a new Next.js app in /usr/src/app.
fi

# nextがインストール済みかをチェック
if ! yarn dev & PID=$! ; then # kill用
  echo "check point 2..."
  yarn install
else					# インストール済みの場合
  sleep 1 # 何らかの処理を行う（例：待機時間など）
  kill $PID # yarn devのプロセスを停止
  echo "check point 3..."
fi

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

# 例: 必要なプロセスのPIDが100と101の場合
KEEP_PIDS="1"

# 不要なプロセス（PIDが1ではない）を検索してキルする
for pid in $(ps -A -o pid | tail -n +2); do
    if [ $pid -ne 1 ] && ! echo "$KEEP_PIDS" | grep -qw "$pid"; then
        kill -9 "$pid"
    fi
	echo "check point ...kill $pid "
done

echo -e "︙\\n︙\\n︙\\n初期設定完了 !!"
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
