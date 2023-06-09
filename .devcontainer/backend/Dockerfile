FROM ruby:3.1.2-alpine

ENV ROOT="/app"
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR ${ROOT}
COPY ./.devcontainer/backend/app/database.yml /tmp/
COPY ./.devcontainer/backend/entrypoint.sh /usr/bin/
COPY ./.devcontainer/backend/app/Gemfile ./.devcontainer/backend/app/Gemfile.lock ${ROOT}/
# COPY ./.devcontainer/backend/prepare.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh 
    # /usr/bin/prepare.sh

# WORKDIR ${ROOT}
# COPY ./.devcontainer/backend/app/Gemfile ./.devcontainer/backend/app/Gemfile.lock ${ROOT}/
# COPY ./.devcontainer/backend/app/Gemfile ./.devcontainer/backend/app/Gemfile.lock ${ROOT}/
# （docker-compose.yml内で）マウントしたボリュームへはペーストできない？上書きされた上で権限変更されるようだ

RUN apk update && \
    apk add \
    alpine-sdk \
    build-base \
    sqlite-dev \
    postgresql-dev \
    tzdata \
    nodejs \
    git vim nano sudo \
    gcompat

# RUN /usr/bin/prepare.sh
# RUN gem update --system --clear-sources --source 'https://rubygems.org' \
#     && gem install bundler -v 2.3.14 --clear-sources --source 'https://rubygems.org'
# RUN bundle _2.3.14_ config set --local without 'production' \
#     && bundle _2.3.14_ install --no-cache

RUN gem update 
#     && gem install bundler -v 2.3.14
# RUN bundle _2.3.14_ install
# RUN rails db:create

# ADD . ${ROOT}

ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-e"]