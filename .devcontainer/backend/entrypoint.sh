#!/bin/sh
set -e

# # 一時的なグループを作成
# groupadd -g 11111 tmpgrp
# # nodeユーザを一時的なグループに一旦所属させる
# usermod -g tmpgrp node
# # もともと所属していたnodeグループを削除
# groupdel node
# # ホストユーザのGIDと同じGIDでnode グループを作成
# groupadd -g $LOCALGID node
# # nodeユーザのGID をホストユーザのGIDに設定
# usermod -g $LOCALGID node
# # nodeユーザのUID をホストユーザのUIDに設定
# usermod -g $LOCALUID node
# # 一時的に作ったグループを削除
# groupdel tmpgrp
# su node

# .bashrcがあるかチェック
if [ ! -e "~/.bashrc" ]; then
    cp -f /tmp/.bashrc ~/
fi

# railsがnew済みかをチェック
if [ ! -e "./config/routes.rb" ]; then
# if [ ! -e "${ROOT}/config/routes.rb" ]; then
  echo 'rails new APIモード を実行する'
  cp /tmp/Gemfile /tmp/Gemfile.lock ${ROOT}
  # --skip入れないとpgのgemないってエラーが出る
  bundle install
  rails new . --force --api --database=postgresql --skip-git --skip-bundle
  cp -f /tmp/.gitignore ${ROOT}
  cp -f /tmp/database.yml ${ROOT}/config/database.yml
  bundle install
  rails db:create
  echo '初期設定 success!!'
fi

# Railsがインストール済かをチェック
if gem list rails -i >/dev/null 2>&1; then
    echo "インストール success!!"
else
    bundle install
    rails db:create
    rails db:seed
    rm -rf config/master.key # 追記（既存keyの削除）
    EDITOR=vim rails credentials:edit # 追記（keyの新規作成）
    # git rm -f --cached *.key # 追記（追跡除外）
    echo "インストール success!!"
fi

# Remove a potentially pre-existing server.pid for Rails.
rm -f ${ROOT}/tmp/pids/server.pid
# 一般的に Rails サーバーを再起動する際に使用されます。
# サーバーが正常に停止されずに終了した場合、PID ファイルが残り、
# サーバーが再起動できないことがあります。そのため、
# サーバーを再起動する前に ${ROOT}/tmp/pids/server.pid ファイルを
# 削除することで、問題を解決することができます。

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"