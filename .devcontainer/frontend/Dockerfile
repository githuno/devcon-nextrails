FROM node:18-alpine

# 環境変数の設定
ENV APP_PATH /usr/src/app
WORKDIR $APP_PATH

RUN npm cache clean --force \
    && npm install -g npm@latest


# FROM node:15.8

# ENV APP /usr/src/app
# RUN mkdir $APP
# WORKDIR $APP

# COPY package.json yarn.lock $APP/
# RUN yarn

# COPY . $APP/

# CMD ["yarn", "dev"]