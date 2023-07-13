#!/bin/sh

# 任意のプロジェクトネームをセット(大文字は禁止っぽい)
export PNAME=myproject
export APP_PATH=/app

# -----------------------0.envファイル作成-------------------------------------|
if [ ! -f ".env" ]; then
  # envファイル作成
    # https://qiita.com/shun_xx/items/5608e553a16d94afacd2
  # Dockerにおける各ファイル間での環境変数の渡し方
    # https://blog.cloud-acct.com/posts/u-env-docker-compose/
    # https://qiita.com/KEINOS/items/518610bc2fdf5999acf2
  cat <<EOT > .env
LOCALUID=`id -u`
LOCALUNAME=`id -un`
LOCALGID=`id -g`
LOCALGNAME=`id -gn`
PNAME=${PNAME}
APP_PATH=${APP_PATH}
EOT
fi
# -----------------------------------------------------------------------------------------|


# -----------------------1.nextアプリ用のファイル群生成--------------------------------------|
if [ ! -d "frontend" ]; then
  # 1-1.必要なファイルを配置
  mkdir frontend
  cp .devcontainer/frontend/docker-compose_f.yml .
  # 1-2.nextアプリファイル群生成
  docker compose -f docker-compose_f.yml -p ${PNAME} run --rm frontend \
  npx create-next-app . --ts --eslint --tailwind --src-dir --app --import-alias "@/*"
  
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
# -----------------------------------------------------------------------------------------|
# または、.git削除したのち
  # git clone ... frontend


# -----------------------2.railsアプリ用のファイル群生成-------------------------------------|
if [ ! -d "backend" ]; then
  # 2-1.設定ファイル準備
  mkdir backend
  cp -f .devcontainer/backend/docker-compose.yml .

  # 2-2.db設定
  mkdir db db/data

  # 2-3.railsアプリ群ビルド
  docker compose -p ${PNAME} up -d --build

# rails generate model Post title:string content:text
# rails db:migrate

# rails generate controller Api::V1::Posts index show create update destroy
fi
# -----------------------------------------------------------------------------------------|
# または、
  # git clone ... backend
# 必要ならdataフォルダをコピー
  # cp -f *** db/data

# 3.まとめてビルド <-未検証
# docker compose -p $PNAME up -d

# CASEの書き出し
# 1.【new create】devcon-nextrailsをクローンして新規環境作成
# 2.【clone create】devcon-nextrailsをクローンして、（devconのgitを削除して）それぞれの元dev環境もクローンしてcompose
# 3.【into project】devcon-nextrailsをクローンして、（devconのgitを削除して）それぞれの進行中リポジをクローンしてcompose



# 3.
# if [ ! -d "db" ]; then
  # run new -> build -> database.yml -> up -> run db:create
  # mkdir db db/data
  
  # docker compose -p $PNAME up -d --build
  # docker compose -p $PNAME stop
  # cp -f .devcontainer/backend/app/database.yml backend/config/database.yml
  # docker compose -p $PNAME up -d # --build

  # docker compose -p $PNAME run --rm backend bundle exec rails new . \
  #   -d postgresql -f --api --database=postgresql --skip-git --skip-bundle
  # docker compose -p $PNAME build
  # cp -f .devcontainer/backend/app/database.yml backend/config/database.yml
  # # docker compose -p $PNAME run --rm backend rails db:create --build
  # docker compose -p $PNAME run --rm backend rails db:create
  # docker compose -p $PNAME up -d
# fi
  # 2-2.railsアプリファイル生成
  
  # docker compose run backend sh
    # bundle exec rails _7.0.3_ new . -d postgresql -f
    # 書き換え
    # rails db:create

  # docker compose run --rm backend bundle exec rails _7.0.3_ new . -d postgresql -f
  # 2-3.image作成(リビルド？) & 設定ファイル書き換え
  # docker compose build
  # sudo cp -f .devcontainer/backend/app/database.yml backend/config/database.yml
  # Dockerfile書き換え
  # sudo cp -f .devcontainer/backend/app/Dockerfile .devcontainer/backend/Dockerfile
  # docker compose run --rm backend

  # docker compose up --build



#     sudo chown ${UID} db/data
#     sudo chmod 766 db/data
# cp -f .devcontainer/backend/docker-compose.yml .
# docker compose run backend sh

# ここで失敗する
# ``` ⠿ Container postgres  Running                                                                                                        0.0s
# Could not find sprockets-rails-3.4.2, pg-1.5.3, puma-5.6.5, importmap-rails-1.1.6, turbo-rails-1.4.0, stimulus-rails-1.2.1, jbuilder-2.11.5, bootsnap-1.16.0, web-console-4.2.0, capybara-3.39.1, selenium-webdriver-4.9.1, webdrivers-5.2.0, sprockets-4.2.0, msgpack-1.7.1, bindex-0.8.1, addressable-2.8.4, regexp_parser-2.8.0, xpath-3.2.0, rubyzip-2.3.2, websocket-1.2.9, public_suffix-5.0.1 in locally installed gems
# Run `bundle install --gemfile /app/Gemfile` to install missing gems.```
# 3.db作成 docker-compose build --no-cache
# docker compose run --rm backend bundle install --gemfile /app/Gemfile
# docker compose run --rm backend rails db:create

# # 6.コンテナ立ち上げ
# docker compose up -d


echo "done!"