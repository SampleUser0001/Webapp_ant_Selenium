# Docker環境でのTomcat起動

このディレクトリには、TomcatをDockerコンテナで起動するための設定が含まれています。

## 使用方法

### 1. WARファイルのビルド

まず、プロジェクトルートでWARファイルをビルドします：

```bash
cd ..
ant war
```

### 2. Dockerコンテナの起動

docker-composeを使用してTomcatコンテナを起動します：

```bash
cd docker
docker-compose up -d
```

### 3. アプリケーションへのアクセス

ブラウザで以下のURLにアクセス：

```
http://localhost:8080/webapp-test-sample/
```

### 4. ログの確認

```bash
docker-compose logs -f tomcat
```

### 5. コンテナの停止

```bash
docker-compose down
```

## トラブルシューティング

### ポート8080が既に使用されている場合

docker-compose.ymlのポート設定を変更してください：

```yaml
ports:
  - "8081:8080"  # ホストの8081ポートをコンテナの8080にマッピング
```

### WARファイルがデプロイされない場合

1. WARファイルが存在するか確認：
   ```bash
   ls -l ../dist/webapp-test-sample.war
   ```

2. コンテナを再起動：
   ```bash
   docker-compose restart
   ```

3. コンテナ内を確認：
   ```bash
   docker exec -it webapp-test-tomcat ls -la /usr/local/tomcat/webapps/
   ```
