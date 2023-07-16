## 環境構築
### 0.docker構築

### 1.初期化
`. ./init.sh`

### 2.サーバ起動確認
各コンテナにVScodeでattach 

- ##### サーバーの立ち上げ
backend: `rails s -e`
frontend: `yarn dev`

- ##### bashへの切り替え
`bash`

### 3.dbの可視化
#### adminerから： [http://localhost:8081]
- ###### Adminerについて
https://zenn.dev/junki555/articles/13da16e4f10c9dee2bb9
https://www.distant-view.co.jp/column/3107/

#### 外部ブラウザから：
- [apidog](https://apidog.com/jp/)
- postman[https://www.postman.com/]

#### 外部vscodeから：
- vscode拡張-> thunder Client[https://marketplace.visualstudio.com/items?itemName=rangav.vscode-thunder-client]
- Rapid API Client[https://marketplace.visualstudio.com/items?itemName=RapidAPI.vscode-rapidapi-client]

#### 内部vscodeから：
- PostgreSQL[https://marketplace.visualstudio.com/items?itemName=ckolkman.vscode-postgres]

 <!-- VScodeのPostgreSQL拡張が便利:https://od10z.wordpress.com/2019/12/17/vscode-extensions-for-postgresql/ -->
    


---
## 参考サイト
https://computer-tb.co.jp/2022/06/22/nginxnext-jsrailspostgresql%E3%82%92%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%9F%E9%96%8B%E7%99%BA%E7%92%B0%E5%A2%83%E6%A7%8B%E7%AF%89/

- →マウントの記述方法について（Permission Deniedエラー）
    - https://zenn.dev/sarisia/articles/0c1db052d09921
    - https://qiita.com/houchiey/items/ef0321956821c05b4b6a
    - https://docs.docker.jp/v1.11/compose/compose-file.html#volumes-volume-driver

---

### よく使うdocker系操作
`docker system prune -a --volumes`

`sudo docker stop $(sudo docker ps -aq)`

`sudo rm -rf backend/ db/ frontend/ .env docker*`

`./.devcontainer/init_create.sh`


`docker compose -p "myproject" stop`

`sudo systemctl stop docker`

`sudo systemctl restart docker`

`sudo rm -rf /var/lib/docker`
