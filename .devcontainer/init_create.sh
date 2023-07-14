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


# -----------------------1.nextアプリ用のディレクトリ生成--------------------------------------|
if [ ! -d "frontend" ]; then
  # 1-1.必要なファイルを配置
  mkdir frontend
  # cp .devcontainer/frontend/docker-compose_f.yml .
  # # 1-2.nextアプリファイル群生成
  # docker compose -f docker-compose_f.yml -p ${PNAME} run --rm frontend \
  # npx create-next-app . --ts --eslint --tailwind --src-dir --app --import-alias "@/*"

fi
# -----------------------------------------------------------------------------------------|


# -----------------------2.railsアプリ用のディレクトリ生成-------------------------------------|
if [ ! -d "backend" ]; then
  # 2-1.設定ファイル準備
  mkdir backend
  

  # 2-2.db設定
  mkdir db db/data

fi
# -----------------------------------------------------------------------------------------|
# 必要ならdataフォルダをコピー
  # cp -f *** db/data

# 3.まとめてビルド <-未検証
cp -f .devcontainer/backend/docker-compose.yml .
docker compose -p ${PNAME} up -d --build


# 3.【into project】devcon-nextrailsをクローンして、（devconのgitを削除して）それぞれの進行中リポジをクローンしてcompose
  # git clone https://github.com/githuno/nextrails-back-1.git backend
  # bundle install -> rails db:migrate -> rails db:seed ?? ->

echo "done!"