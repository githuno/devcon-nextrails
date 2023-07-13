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

if [ ! -e "./config/routes.rb" ]; then
# if [ ! -e "${ROOT}/config/routes.rb" ]; then
  echo 'rails new APIモード を実行する'
  cp /tmp/Gemfile /tmp/Gemfile.lock ${ROOT}
  # --skip入れないとpgのgemないってエラーが出る
  bundle install
  rails new . --force --api --database=postgresql --skip-git --skip-bundle
  cp -f /tmp/database.yml ${ROOT}/config/database.yml
  cp -f /tmp/.bashrc ~/
  bundle install
  rails db:create
  echo '初期設定成功！！'
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