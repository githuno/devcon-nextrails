#!/bin/sh
set -e

echo "エントリー"
# .bashrcがあるかチェック
if [ ! -e "~/.bashrc" ]; then
    cp -f /tmp/.bashrc ~/
fi

# nextがcreate済みかをチェック
if [ ! -e "next.config.js" ]; then
    env CI=true npx create-next-app . --ts --eslint --tailwind --src-dir --app --import-alias "@/*"
    # npx create-next-app . --ts --eslint --tailwind --src-dir --app --import-alias "@/*"
    echo '初期設定 success!!'
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
if ! npx next -v; then
    yarn install
    echo "インストール success!!"
else
    echo "インストール success!!"
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"