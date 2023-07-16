#!/bin/sh

echo "サーバーを起動します。"

yarn dev &
PID=$! # yarn devのプロセスIDを取得
sleep 10 # 何らかの処理を行う（例：待機時間など）
kill $PID # yarn devのプロセスを停止

echo "サーバーを停止しました。"