#!/bin/sh

read -p "プロジェクト名を入力してください: " PNAME
current_folder=$(basename "$(pwd)")
export APP_PATH=/app

# クローンリポジトリの初期URL
FRONT_URL=https://github.com/githuno/nextrails-ini-frontend.git
BACK_URL=https://github.com/githuno/nextrails-ini-backtend.git
DEV_CON=https://github.com/githuno/devcon-nextrails.git 

cat <<EOT > $Pfolder/.env
LOCALUID=`id -u`
LOCALUNAME=`id -un`
LOCALGID=`id -g`
LOCALGNAME=`id -gn`
PNAME=${PNAME}
APP_PATH=${APP_PATH}
EOT

# -----------------------------------------------------------------------------------------|

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
# -----------------------------------------------------------------------------------------|

# Pfolderに.devcontainerがなければPNAMEを作成（devconをクローン:該当フォルダが空なら同名でclone可能）
if [ ! -d $Pfolder/.devcontainer ]; then
    git clone $DEV_CON $Pfolder
    # git削除
    read -p "コンテナ準備用gitを削除します: " INPUT
    if [ -z "$INPUT" ]; then
        rm -rf $Pfolder/.git
        echo ".gitを削除しました。"
    else
        echo ".gitは削除しませんでした。"
    fi
else
    read -p "${Pfolder}は既に存在しますが、上書きして更新していきますか? (y/N): " yn
    if [ ! "$yn" = "y" ] && [ ! "$yn" = "Y" ]; then
        echo "終了します。"
        exit
    fi
fi

# -----------------------------------------------------------------------------------------|

echo "【フロントエンド】"
read -p "クローンしたい特定のリポジトリがあればURLを入力（ENTERでスキップ）: " INPUT
if [ ! -z "$INPUT" ]; then
    FRONT_URL=${INPUT}
fi

if [ ! -d $Pfolder/frontend ]; then
    read -p "frontendを${FRONT_URL}で初期化します。("mk"でnew): " INPUT
    if [ "$INPUT" == "mk" ]; then
        mkdir $Pfolder/frontend
    else
        git clone $FRONT_URL $Pfolder/frontend
        
        # git削除
        read -p "frontendのgitを削除します: " INPUT
        if [ -z "$INPUT" ]; then
            rm -rf $Pfolder/.git
            echo ".gitを削除しました。"
        else
            echo ".gitは削除しませんでした。"
        fi
    fi
else
    read -p "既存のfrontendを${FRONT_URL}で上書きしますか? (y/N): " yn
    case "$yn" in
    [yY]*)
        rm -rf $Pfolder/frontend
        git clone $FRONT_URL $Pfolder/frontend

        # git削除
        read -p "frontendのgitを削除します: " INPUT
        if [ -z "$INPUT" ]; then
            rm -rf $Pfolder/.git
            echo ".gitを削除しました。"
        else
            echo ".gitは削除しませんでした。"
        fi;;
    mk)
        rm -rf $Pfolder/frontend
        mkdir $Pfolder/frontend;;
    *)
        echo "終了します。"
        exit
    esac   
fi
echo -e "︙\\n︙\\n︙\\n   frontend is initialized!!"
# -----------------------------------------------------------------------------------------|
echo "【バックエンド】"
read -p "クローンしたい特定のリポジトリがあればURLを入力（ENTERでスキップ）: " INPUT
if [ ! -z "$INPUT" ]; then
    BACK_URL=${INPUT}
fi

if [ ! -d $Pfolder/backend ]; then
    read -p "backendを${BACK_URL}で初期化します。("mk"でnew): " INPUT
    if [ "$INPUT" == "mk" ]; then
        mkdir $Pfolder/backend
    else
        git clone $BACK_URL $Pfolder/backend

        # git削除
        read -p "backendのgitを削除します: " INPUT
        if [ -z "$INPUT" ]; then
            rm -rf $Pfolder/.git
            echo ".gitを削除しました。"
        else
            echo ".gitは削除しませんでした。"
        fi
    fi
else
    read -p "既存のbackendを${BACK_URL}で上書きしますか? (y/N): " yn
    case "$yn" in
    [yY]*)
        rm -rf $Pfolder/backend
        git clone $BACK_URL $Pfolder/backend

        # git削除
        read -p "backendのgitを削除します: " INPUT
        if [ -z "$INPUT" ]; then
            rm -rf $Pfolder/.git
            echo ".gitを削除しました。"
        else
            echo ".gitは削除しませんでした。"
        fi;;
    mk)
        rm -rf $Pfolder/backend
        mkdir $Pfolder/backend;;
    *)
        echo "終了します。"
        exit
    esac   
fi
echo -e "︙\\n︙\\n︙\\n   backend is initialized!!"
# -----------------------------------------------------------------------------------------|
if [ ! -d $Pfolder/db ]; then
    mkdir $Pfolder/db $Pfolder/db/data
else
    read -p "既存のdbを初期化しますか? (y/N): " yn
    case "$yn" in
    [yY]*) 
        rm -rf $Pfolder/db
        mkdir $Pfolder/db $Pfolder/db/data
        echo "db is initialized!!";;
    mk)
        rm -rf db/
        mkdir $Pfolder/db $Pfolder/db/data;;
    *)
        echo "終了します。"
        exit;;
    esac   
fi
echo -e "︙\\n︙\\n︙\\n   db is initialized!!"
# -----------------------------------------------------------------------------------------|
# docker compose up -d 【-buildつけることでキャッシュを使用せずcompose.ymlや依存関係の変更を反映させて新たにイメージをつくります】
cp $Pfolder/.devcontainer/docker-compose.yml $Pfolder/
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