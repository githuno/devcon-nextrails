#!/bin/sh

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
if ! yarn dev; then
    echo "check point 2..."
    yarn install
    echo "インストール success!!"
else
    echo "check point 3..."
    echo "インストール success!!"
fi

# .nextを生成するために一度yarn devを実行
echo "サーバーを起動します。"
yarn dev &
PID=$! # yarn devのプロセスIDを取得
sleep 10 # 何らかの処理を行う（例：待機時間など）
kill $PID # yarn devのプロセスを停止
echo "サーバーを停止しました。"

# オーナー変更
# groupmod --non-unique --gid 1001 node
# usermod --non-unique --uid 1001 --gid 1001 node
groupmod --non-unique --gid ${LOCALGID} ${LOCALGNAME}
usermod --non-unique --uid ${LOCALUID} --gid ${LOCALGID} ${LOCALUNAME}
chown -R ${LOCALUNAME}:${LOCALGNAME} ${APP_PATH}
# su - ${LOCALUNAME}
echo "owner changed !!"

# .bashrcがあるかチェック
if [ ! -e "~/.bashrc" ]; then
    cp -f /tmp/.bashrc ~/
    echo ".bashrc copied !"
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"