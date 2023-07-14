#!/bin/sh

# projectディレクトリの作成と移動 ＆ initial_clone.sh（project名を入力させ、そこにいればOK。いなければpnameを入力させて作成移動）
# .devcontainerがなければcloneして、.gitを削除
# 最新のfrontend,backend,dbディレクトリをクローン（URLを環境変数として）
# docker compose up -d 【-buildつける？】