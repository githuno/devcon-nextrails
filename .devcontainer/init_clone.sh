#!/bin/sh

read -p "プロジェクト名を入力してください: " PNAME
current_folder=$(basename "$(pwd)")
export APP_PATH=/app

echo "現在の階層は $current_folder 下 です"
read -p "ここに作成しますか? (y/N):" yn
if [ "$yn" = "y" ] || [ "$yn" = "Y" ]; then
    Pfolder="./${PNAME}"
else
    read -p "作成するディレクトリを指定してください: " dir
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

if [ ! -d $Pfolder/frontend ]; then
    git clone https://github.com/githuno/nextrails-ini-frontend.git $Pfolder/frontend
    echo "frontend is initialized!!"
else
    read -p "フロントエンドを初期化しますか? (y/N):" yn
    case "$yn" in
        [yY]*) 
        rm -rf $Pfolder/frontend
        git clone https://github.com/githuno/nextrails-ini-frontend.git $Pfolder/frontend
        echo "frontend is initialized!!";;
            *)  ;;
    esac   
fi
if [ ! -d $Pfolder/backend ]; then
    git clone https://github.com/githuno/nextrails-ini-backend.git $Pfolder/backend
    echo "backend is initialized!!"
else
    read -p "バックエンドを初期化しますか? (y/N):" yn
    case "$yn" in
        [yY]*) 
        rm -rf $Pfolder/backend
        git clone https://github.com/githuno/nextrails-ini-backend.git $Pfolder/backend
        echo "backend is initialized!!";;
            *)  ;;
    esac   
fi
if [ ! -d $Pfolder/db ]; then
    mkdir $Pfolder/db $Pfolder/db/data
    echo "db is initialized!!"
else
    read -p "データベースを初期化しますか? (y/N):" yn
    case "$yn" in
        [yY]*) 
        rm -rf $Pfolder/db
        mkdir $Pfolder/db $Pfolder/db/data
        echo "db is initialized!!";;
            *)  ;;
    esac   
fi

cat <<EOT > $Pfolder/.env
LOCALUID=`id -u`
LOCALUNAME=`id -un`
LOCALGID=`id -g`
LOCALGNAME=`id -gn`
PNAME=${PNAME}
APP_PATH=${APP_PATH}
EOT

cp $Pfolder/.devcontainer/docker-compose.yml $Pfolder/

# 各ディレクトリの.gitを削除
rm -rf $Pfolder/.git $Pfolder/frontend/.git $Pfolder/backend/.git
# docker compose up -d 【-buildつけることでキャッシュを使用せずcompose.ymlや依存関係の変更を反映させて新たにイメージをつくります】
docker compose -f ${Pfolder}/docker-compose.yml -p ${PNAME} up -d --build

# Pfolderへ移動
if [ ! "${current_folder}" = "${PNAME}" ]; then

#   # ファイル自身のパスを取得し、Pfolderに自身を複製
#   self_name=$(basename "$BASH_SOURCE")
#   self_path=$(cd $(dirname $0); pwd)"/$self_name"
#   cp "$self_path" "$Pfolder"
#   echo "cd $Pfolder で移動してください"

    cd $Pfolder
    #  . .devcontainer/initial_clone.sh であれば移動可能：https://atmarkit.itmedia.co.jp/bbs/phpBB/viewtopic.php?topic=5801&forum=10
    # $ . test.sh
    # ファイル読み込み -> 実行 (ディレクトリ移動)
    # $ ./test.sh
    # bash起動 -> ファイル読み込み -> 実行 (ディレクトリ移動) -> bash終了  
fi