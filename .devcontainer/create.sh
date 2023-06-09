#!/bin/sh
# 任意のプロジェクトネームをセット(大文字は禁止っぽい)
export PNAME="myproject"

# 1.nextアプリ用のファイル群生成（インストール中なにか聞かれたらyまたはenterでデフォルト設定のまま進める）
if [ ! -d "frontend" ]; then
  # 1-1.必要なファイルを配置
  mkdir frontend
  cp .devcontainer/frontend/docker-compose_f.yml .
  # 1-2.nextアプリファイル群生成
  docker compose -f docker-compose_f.yml -p $PNAME run --rm frontend npx create-next-app .
fi

# 2.railsアプリ用のファイル群生成
if [ ! -d "backend" ]; then
  # 2-1.設定ファイル準備
  mkdir backend
  if [ ! -f "backend/Gemfile" ]; then
    cp .devcontainer/backend/app/Gemfile backend/
  fi
  if [ ! -f "backend/Gemfile.lock" ]; then
    cp .devcontainer/backend/app/Gemfile.lock backend/
  fi
fi

# 3.
if [ ! -d "db" ]; then
  mkdir db db/data
  cp -f .devcontainer/backend/docker-compose.yml .
  docker compose -p $PNAME up -d --build
  docker compose -p $PNAME stop
  cp -f .devcontainer/backend/app/database.yml backend/config/database.yml
  docker compose -p $PNAME up -d --build
  # docker compose run --rm backend bundle exec rails _7.0.3_ new . -d postgresql -f
  # # docker compose build
  # sudo cp -f .devcontainer/backend/app/database.yml backend/config/database.yml
  # docker compose run --rm backend rails db:create --build
  # docker compose up -d
fi
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