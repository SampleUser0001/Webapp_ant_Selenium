# Webアプリテストサンプル

Tomcat + JUnit 5 + Selenium + Apache Ivyを使用したWebアプリケーションテストのサンプルプロジェクトです。

**Apache Ivy**を使用して依存関係を自動管理しているため、手動でJARファイルをダウンロードする必要はありません。

## クイックスタート

すぐにアプリケーションを試したい場合：

```bash
# 1. 依存関係を解決（Ivyが自動でダウンロード）
ant resolve

# 2. WARファイルをビルド
ant war

# 3. Dockerでアプリケーションを起動
cd docker
docker-compose up -d

# 4. ブラウザでアクセス
# http://localhost:8080/webapp-test-sample/
```

テストを実行したい場合：
```bash
# ChromeDriverをセットアップ
ant setup-chromedriver

# テストを実行
ant test
```

停止するには：
```bash
cd docker
docker-compose down
```

## プロジェクト構成

```
webapp_ant_selenium/
├── build.xml                    # Antビルドファイル
├── ivy.xml                      # Ivy依存関係定義ファイル
├── setup-chromedriver.sh        # ChromeDriver自動ダウンロードスクリプト
├── chromedriver                 # ChromeDriver実行ファイル（自動生成、git管理外）
├── ant-lib/                     # Apache Ivy JAR
│   └── ivy-2.5.3.jar           # Ivy本体
├── src/                         # アプリケーションソースコード
│   └── com/example/webapp/
│       └── HelloServlet.java    # サンプルサーブレット
├── test/                        # テストコード
│   └── com/example/webapp/
│       └── WebAppSeleniumTest.java  # Seleniumテスト
├── webapp/                      # Webアプリケーションリソース
│   ├── index.jsp                # トップページ
│   └── WEB-INF/
│       └── web.xml              # Web設定ファイル
├── docker/                      # Docker環境設定
│   ├── docker-compose.yml       # Docker Compose設定
│   ├── Dockerfile               # Dockerイメージ定義
│   └── README.md                # Docker環境の説明
├── lib/                         # 依存ライブラリ（Ivyが自動生成、git管理外）
│   ├── compile/                 # コンパイル用ライブラリ
│   └── test/                    # テスト用ライブラリ
├── build/                       # ビルド成果物（自動生成、git管理外）
│   └── test-reports/            # テストレポート
│       ├── xml/                 # XMLレポート（CI/CD統合用）
│       └── html/                # HTMLレポート（ブラウザ閲覧用）
└── dist/                        # 配布用WARファイル（自動生成、git管理外）
```

## 必要な環境

- **Java**: JDK 11以上
- **Apache Ant**: 1.10以上
- **Apache Ivy**: 2.5.3（プロジェクトに同梱済み）
- **Docker & Docker Compose**: 最新版（推奨）
- **Apache Tomcat**: 9.0以上（Dockerを使用しない場合）
- **Chrome/Chromium**: 最新版（Seleniumテスト用）
- **ChromeDriver**: Chromeのバージョンに対応したもの（プロジェクトルートに配置済み）

## セットアップ

### 1. 依存関係の解決（Apache Ivy）

プロジェクトでは**Apache Ivy 2.5.3**を使用して依存関係を自動管理しています。

```bash
ant resolve
```

このコマンドで以下が自動的にダウンロードされます：
- Jakarta Servlet API 5.0.0（Tomcat 10用）
- Jakarta JSP API 3.0.0
- JUnit 5.10.1（テストフレームワーク）
- Selenium WebDriver 4.15.0とその全依存関係
- その他必要なライブラリ（合計54個のJAR、約25MB）

**注意**: `download-dependencies.sh`は旧版です。Ivyを使用するため不要になりました。

### 2. ChromeDriverのインストール

Seleniumテストを実行するには、ChromeDriverが必要です。

#### 自動セットアップ（推奨）

Chromeのバージョンを自動検出して、対応するChromeDriverをダウンロードします：

```bash
ant setup-chromedriver
```

このコマンドで以下が自動実行されます：
- システムにインストールされたChromeのバージョンを検出
- 対応するChromeDriverを[Chrome for Testing](https://googlechromelabs.github.io/chrome-for-testing/#stable)からダウンロード
- プロジェクトルートに配置して実行権限を付与

#### 手動セットアップ

自動セットアップが失敗する場合は、以下の手順で手動ダウンロードできます：

```bash
# 1. Chromeのバージョンを確認
google-chrome --version

# 2. setup-chromedriver.shを実行（対話的に手動URLを案内）
./setup-chromedriver.sh
```

## ビルドとテスト

### 利用可能なAntターゲット

```bash
ant help              # ヘルプを表示
ant resolve           # 依存関係を解決（Ivyが自動ダウンロード）
ant setup-chromedriver # ChromeDriverを自動ダウンロード
ant clean             # ビルド成果物を削除
ant compile           # ソースコードをコンパイル（依存関係を自動解決）
ant compile-test      # テストコードをコンパイル
ant war               # WARファイルを作成
ant test              # JUnit 5テストを実行
ant all               # クリーン、ビルド、テストをすべて実行
```

**注意**: `ant compile`、`ant war`などは自動的に`ant resolve`を実行するため、通常は明示的に`ant resolve`を実行する必要はありません。

### WARファイルの作成

```bash
ant war
```

成果物は `dist/webapp-test-sample.war` に生成されます。

### テストの実行

```bash
ant test
```

テストが完了すると、以下の形式でレポートが生成されます：

**HTMLレポート**（ブラウザで閲覧可能）:
- メインページ: `build/test-reports/html/index.html`
- 各テストクラスの詳細レポート
- 失敗したテストのスタックトレース
- テスト実行時間の統計

**XMLレポート**（CI/CD統合用）:
- `build/test-reports/xml/TEST-*.xml`
- `build/test-reports/xml/TESTS-TestSuites.xml`

HTMLレポートをブラウザで開くには：
```bash
# Linuxの場合
xdg-open build/test-reports/html/index.html

# macOSの場合
open build/test-reports/html/index.html
```

## アプリケーションのデプロイ

### 方法1: Docker環境で起動（推奨）

Dockerを使用すると、環境構築が簡単で確実にアプリケーションを起動できます。

1. WARファイルを作成：
   ```bash
   ant war
   ```

2. Dockerコンテナを起動：
   ```bash
   cd docker
   docker-compose up -d
   ```

3. ブラウザで以下にアクセス：
   ```
   http://localhost:8080/webapp-test-sample/
   ```

4. コンテナを停止：
   ```bash
   docker-compose down
   ```

5. ログを確認：
   ```bash
   docker-compose logs -f tomcat
   ```

詳細は `docker/README.md` を参照してください。

### 方法2: Tomcatに手動デプロイ

1. WARファイルを作成：
   ```bash
   ant war
   ```

2. 生成されたWARファイルをTomcatのwebappsディレクトリにコピー：
   ```bash
   cp dist/webapp-test-sample.war $CATALINA_HOME/webapps/
   ```

3. Tomcatを起動：
   ```bash
   $CATALINA_HOME/bin/startup.sh
   ```

4. ブラウザで以下にアクセス：
   ```
   http://localhost:8080/webapp-test-sample/
   ```

## アプリケーション機能

### 1. トップページ（index.jsp）
- URL: `http://localhost:8080/webapp-test-sample/`
- アプリケーションの説明とHello Servletへのリンクを表示

### 2. Hello Servlet
- URL: `http://localhost:8080/webapp-test-sample/hello`
- パラメータなし: "Hello, World!" と表示
- パラメータあり: `?name=YourName` で "Hello, YourName!" と表示
- フォームから名前を入力して送信可能

## テストについて

このプロジェクトは**JUnit 5 (JUnit Jupiter)** を使用しています。Antの`<junitlauncher>`タスクでテストを実行します。

### WebAppSeleniumTest.java

以下の5つのテストケースが含まれています：

1. **testIndexPage**: トップページの要素が正しく表示されるか確認
2. **testHelloServletDefaultGreeting**: デフォルトの挨拶メッセージを確認
3. **testHelloServletWithParameter**: URLパラメータ付きの挨拶を確認
4. **testHelloServletFormSubmission**: フォーム送信機能を確認
5. **testNavigationFromIndexToHello**: ページ間のナビゲーションを確認

### テストの実行オプション

テストはヘッドレスモード（GUI非表示）で実行されます。GUIで実行したい場合は、`WebAppSeleniumTest.java`の以下の行をコメントアウトしてください：

```java
// options.addArguments("--headless"); // この行をコメントアウト
```

## プロジェクトの現状

### ✅ 動作している機能

1. **依存関係管理（Apache Ivy）**
   - Apache Ivy 2.5.3による依存関係の自動管理
   - 54個のJAR（約25MB）を自動ダウンロード
   - Jakarta EE 9（Tomcat 10対応）への対応完了
   - Selenium WebDriverとその全依存関係を自動解決

2. **ビルドシステム**
   - Antビルドスクリプト（build.xml）が正常に動作
   - ソースコードとテストコードのコンパイルが成功
   - WARファイルの生成が正常に完了

3. **Webアプリケーション**
   - HelloServlet（サーブレット）が正常に動作
   - index.jspが正常に表示
   - フォーム送信とパラメータ処理が正常に動作
   - Docker環境でのTomcatデプロイが成功
   - `http://localhost:8080/webapp-test-sample/` でアクセス可能

4. **テストコンパイル**
   - JUnit 5を使用したテストコードのコンパイルが成功
   - テストクラス（WebAppSeleniumTest.java）が正常にコンパイル完了

### ⚠️ 既知の課題

**Seleniumテストの実行**

~~Selenium WebDriverの依存関係が複雑で、Antによる手動管理では一部のクラスが不足していました。~~

**✅ 解決済み（Apache Ivy導入により）**

Apache Ivy 2.5.3を導入したことで、以下の問題が解決されました：
- Selenium WebDriverとその全依存関係（54個のJAR）を自動管理
- Jakarta EE 9（Tomcat 10）への対応完了
- テストコードのコンパイルが正常に完了

**残っている制約：**
- テストを実行するには、アプリケーションが`http://localhost:8080`で起動している必要があります
- ChromeDriverが正しくインストールされている必要があります

**テスト実行前の準備：**
```bash
# 1. アプリケーションをDockerで起動
cd docker
docker-compose up -d

# 2. テストを実行
cd ..
ant test
```

## トラブルシューティング

### コンパイルエラー

- Java 11以上がインストールされているか確認
- `lib/`ディレクトリに必要なJARファイルがすべて存在するか確認

### Seleniumテストの失敗

- Chromeブラウザがインストールされているか確認
- ChromeDriverがChromeのバージョンと一致しているか確認
- アプリケーションがポート8080で起動しているか確認
- ファイアウォールがlocalhostへのアクセスをブロックしていないか確認

### Tomcatデプロイの問題

- Tomcatが正しく起動しているか確認
- ポート8080が他のプロセスで使用されていないか確認
- Tomcatのログファイル（`$CATALINA_HOME/logs/catalina.out`）でエラーを確認

## ライセンス

このプロジェクトはサンプルコードです。自由に使用、改変できます。

## Apache Ivyについて

### Ivyとは

Apache Ivyは、Antと統合できる依存関係管理ツールです。Mavenのような依存関係の自動解決機能を持ちながら、Antの柔軟性を維持できます。

### このプロジェクトでのIvy使用例

**ivy.xml**（依存関係定義）:
```xml
<dependencies>
    <!-- Jakarta EE Servlet API -->
    <dependency org="jakarta.servlet" name="jakarta.servlet-api" rev="5.0.0"/>

    <!-- JUnit 5 -->
    <dependency org="org.junit.jupiter" name="junit-jupiter-api" rev="5.10.1"/>

    <!-- Selenium WebDriver -->
    <dependency org="org.seleniumhq.selenium" name="selenium-java" rev="4.15.0"/>
</dependencies>
```

Ivyが自動的に推移的依存関係を解決し、必要な全てのJARファイルをダウンロードします。

### Ivyの利点

- ✅ **自動依存関係解決**: 推移的依存関係を自動で取得
- ✅ **Antとの統合**: 既存のAntビルドスクリプトに簡単に追加
- ✅ **Mavenリポジトリ対応**: Maven Centralから直接ダウンロード
- ✅ **柔軟な設定**: Antの自由度を維持

## 参考リンク

- [Apache Ant](https://ant.apache.org/)
- [Apache Ivy](https://ant.apache.org/ivy/)
- [Apache Tomcat](https://tomcat.apache.org/)
- [JUnit 5](https://junit.org/junit5/)
- [Selenium WebDriver](https://www.selenium.dev/)
- [ChromeDriver](https://chromedriver.chromium.org/)
- [Chrome for Testing](https://googlechromelabs.github.io/chrome-for-testing/#stable)
