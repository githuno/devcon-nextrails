#!/bin/sh
set -e

bundle install

if [ ! -e "${ROOT}/config/routes.rb" ]; then
  echo 'rails new APIモード を実行する'
#   --skip入れないとpgのgemないってエラーが出る
  rails new . --force --api --database=postgresql --skip-git --skip-bundle
  bundle install
#   外から書き換えできるよう権限変更
#   chmod 666 config/database.yml 
  mv -f /tmp/database.yml config/database.yml 
  rails db:create
fi

# Remove a potentially pre-existing server.pid for Rails.
rm -f ${ROOT}/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"