#!/bin/sh

# 任意のプロジェクトネームをセット(大文字は禁止っぽい)
read -p "プロジェクト名を入力してください: " PNAME
current_folder=$(basename "$(pwd)")
export APP_PATH=/app

echo "現在の階層は $current_folder 下 です"
read -p "ここに作成しますか? (y/N):" yn
if [ "$yn" = "y" ] || [ "$yn" = "Y" ]; then
    Pfolder="./${PNAME}"
else
    read -p "作成するディレクトリを指定してください :" dir
    Pfolder="${dir}/${PNAME}"
fi

if [ ! -d $Pfolder ]; then
    mkdir $Pfolder
fi

# Pfolderに.devcontainerがなければPNAMEを作成（devconをクローン:該当フォルダが空なら同名でclone可能）
if [ ! -d $Pfolder/.devcontainer ]; then
    git clone https://github.com/githuno/devcon-nextrails.git $Pfolder
else
    read -p "${Pfolder}は既に存在しますが、続けますか? (y/N):" yn
    if [ ! "$yn" = "y" ] && [ ! "$yn" = "Y" ]; then
        echo "終了します"
        exit
    fi
fi

# -----------------------0.envファイル作成-------------------------------------|
if [ ! -f "$Pfolder/.env" ]; then
  # envファイル作成
    # https://qiita.com/shun_xx/items/5608e553a16d94afacd2
  # Dockerにおける各ファイル間での環境変数の渡し方
    # https://blog.cloud-acct.com/posts/u-env-docker-compose/
    # https://qiita.com/KEINOS/items/518610bc2fdf5999acf2
  cat <<EOT > $Pfolder/.env
LOCALUID=`id -u`
LOCALUNAME=`id -un`
LOCALGID=`id -g`
LOCALGNAME=`id -gn`
PNAME=${PNAME}
APP_PATH=${APP_PATH}
EOT
fi
# -----------------------------------------------------------------------------------------|

cp $Pfolder/.devcontainer/backend/docker-compose.yml $Pfolder/

# -----------------------1.nextアプリ用のディレクトリ生成--------------------------------------|
if [ ! -d "$Pfolder/frontend" ]; then
  # 1-1.必要なファイルを配置
  mkdir ${Pfolder}/frontend
  # # 1-2.nextアプリファイル群生成
  docker compose -f ${Pfolder}/docker-compose.yml -p ${PNAME} run --rm front_${PNAME} \
  npx create-next-app . --ts --eslint --tailwind --src-dir --app --import-alias "@/*"

fi
# -----------------------------------------------------------------------------------------|


# -----------------------2.railsアプリ用のディレクトリ生成-------------------------------------|
if [ ! -d "$Pfolder/backend" ]; then
  # 2-1.設定ファイル準備
  mkdir ${Pfolder}/backend
  

  # 2-2.db設定
  mkdir db ${Pfolder}/db/data

fi
# -----------------------------------------------------------------------------------------|
# 必要ならdataフォルダをコピー
  # cp -f *** db/data

# 3.まとめてビルド <-未検証
docker compose -f ${Pfolder}/docker-compose.yml -p ${PNAME} up -d --build

# 3.【into project】devcon-nextrailsをクローンして、（devconのgitを削除して）それぞれの進行中リポジをクローンしてcompose
  # git clone https://github.com/githuno/nextrails-back-1.git backend
  # bundle install -> rails db:migrate -> rails db:seed ?? ->

echo "done!"