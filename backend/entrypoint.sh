#!/bin/sh
set -e

# 既存.bashrcがなければtmpからコピー
if [ ! -e "~/.bashrc" ]; then
    cp -f /tmp/.bashrc ~/
    source ~/.bashrc
fi

# railsがnew済みかをチェック
if [ ! -e "./config/routes.rb" ]; then
    echo 'rails new APIモード を実行する'
    cp /tmp/Gemfile /tmp/Gemfile.lock ${ROOT}
    # --skip入れないとpgのgemないってエラーが出る
    bundle install
    rails new . --force --api --database=postgresql --skip-git --skip-bundle
    cp -f /tmp/.gitignore ${ROOT}
    cp -f /tmp/database.yml ${ROOT}/config/database.yml
    gem update --system
    bundle update --bundler
    bundle install
    rails db:create
    echo '>> rails new success!!'
fi

# Railsがインストール済かをチェック
if ! rails -v; then
    gem update --system
    bundle update --bundler
    bundle install
    echo ">> bundle install success!!"
    if [ -e "db/migrate" ]; then
        rails db:migrate
        rails db:seed
        echo ">> db:migrate success!!"
    else
        rails db:create
        echo ">> db:create success!!"
    fi
    if [ ! -e "config/master.key" ]; then
        # master.key の再生成
        rm -f config/master.key config/credentials.yml.enc # 既存keyの削除
        rails credentials:edit # keyの作成
        EDITOR=true rails credentials:edit # credentials.yml.enc の再作成
        echo ">> master.key created!!"
    fi
fi

# Remove a potentially pre-existing server.pid for Rails.
rm -f ${ROOT}/tmp/pids/server.pid
# 一般的に Rails サーバーを再起動する際に使用されます。
# サーバーが正常に停止されずに終了した場合、PID ファイルが残り、
# サーバーが再起動できないことがあります。そのため、
# サーバーを再起動する前に ${ROOT}/tmp/pids/server.pid ファイルを
# 削除することで、問題を解決することができます。

# tailscale
nohup tailscaled --tun=userspace-networking --socks5-server=localhost:1055 --outbound-http-proxy-listen=localhost:1055 > /dev/null 2>&1 &
echo ">> tailscaled.. success!!"

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"