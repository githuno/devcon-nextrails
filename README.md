## 環境構築
1.git Clone
git clone 

2.ディレクトリ移動
cd Next_rails/

3.スクリプト実行
./.devcontainer/create.sh

## 最新リポジトリ反映

https://computer-tb.co.jp/2022/06/22/nginxnext-jsrailspostgresql%E3%82%92%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%9F%E9%96%8B%E7%99%BA%E7%92%B0%E5%A2%83%E6%A7%8B%E7%AF%89/
- →マウントの記述方法について（Permission Deniedエラー）
    - https://zenn.dev/sarisia/articles/0c1db052d09921
    - https://qiita.com/houchiey/items/ef0321956821c05b4b6a
    - https://docs.docker.jp/v1.11/compose/compose-file.html#volumes-volume-driver



-----------------

削除
sudo rm -rf frontend/ backend/ docker* db/
docker compose -p "myproject" stop
docker system prune -a --volumes

起動
docker compose -p myproject up -d 


### Adminerについて
https://zenn.dev/junki555/articles/13da16e4f10c9dee2bb9
https://www.distant-view.co.jp/column/3107/