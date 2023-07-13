## 1.環境構築
0.docker構築

1.git Clone
`git clone https://github.com/githuno/dev_next-rails.git Next-rails`

2.ディレクトリ移動
`cd dev_next-rails/`

3.スクリプト実行
`./.devcontainer/create.sh`

4.server起動確認
attach vscode

## 2.最新リポジトリ反映

1.[.git]削除（環境構築用のgitを削除）
各環境にgitディレクトリがあるならpullでいける？
cloneではなさそう。。

https://computer-tb.co.jp/2022/06/22/nginxnext-jsrailspostgresql%E3%82%92%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%9F%E9%96%8B%E7%99%BA%E7%92%B0%E5%A2%83%E6%A7%8B%E7%AF%89/
- →マウントの記述方法について（Permission Deniedエラー）
    - https://zenn.dev/sarisia/articles/0c1db052d09921
    - https://qiita.com/houchiey/items/ef0321956821c05b4b6a
    - https://docs.docker.jp/v1.11/compose/compose-file.html#volumes-volume-driver



-----------------
### サーバーの立ち上げ
backend: `rails s -e`

frontend: `yarn dev`


### bashへの切り替え
bash

### dbの可視化
外部ブラウザから：  apidog ｜ postman
外部vscodeから：   vscode拡張-> thunder Client ｜ Rapid API Client
内部vscodeから：    PostgreSQL[https://marketplace.visualstudio.com/items?itemName=ckolkman.vscode-postgres]
 <!-- VScodeのPostgreSQL拡張が便利:https://od10z.wordpress.com/2019/12/17/vscode-extensions-for-postgresql/ -->
    

### Adminerについて
https://zenn.dev/junki555/articles/13da16e4f10c9dee2bb9
https://www.distant-view.co.jp/column/3107/

### よく使うdocker系操作
`docker system prune -a --volumes`

`sudo docker stop $(sudo docker ps -aq)`

`sudo rm -rf backend/ db/ frontend/ .env docker*`

`./.devcontainer/create.sh`


`docker compose -p "myproject" stop`

`sudo systemctl stop docker`

`sudo systemctl restart docker`

`sudo rm -rf /var/lib/docker`
