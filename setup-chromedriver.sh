#!/bin/bash

# ChromeDriverセットアップスクリプト
# Chromeのバージョンを検出して対応するChromeDriverを自動ダウンロード

set -e

echo "=========================================="
echo "ChromeDriver セットアップ"
echo "=========================================="

# プロジェクトルートディレクトリ
PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
CHROMEDRIVER_PATH="${PROJECT_ROOT}/chromedriver"

# 既にChromeDriverが存在する場合
if [ -f "${CHROMEDRIVER_PATH}" ]; then
    echo "既存のChromeDriverが見つかりました: ${CHROMEDRIVER_PATH}"
    EXISTING_VERSION=$(${CHROMEDRIVER_PATH} --version 2>/dev/null | awk '{print $2}' || echo "unknown")
    echo "既存のバージョン: ${EXISTING_VERSION}"
    read -p "再ダウンロードしますか? (y/N): " CONFIRM
    if [[ ! "${CONFIRM}" =~ ^[Yy]$ ]]; then
        echo "スキップしました。"
        exit 0
    fi
    rm -f "${CHROMEDRIVER_PATH}"
fi

# Chromeのバージョンを検出
echo ""
echo "Chromeのバージョンを検出しています..."

CHROME_VERSION=""
if command -v google-chrome &> /dev/null; then
    CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
    echo "Google Chrome バージョン: ${CHROME_VERSION}"
elif command -v chromium &> /dev/null; then
    CHROME_VERSION=$(chromium --version | awk '{print $2}')
    echo "Chromium バージョン: ${CHROME_VERSION}"
elif command -v chromium-browser &> /dev/null; then
    CHROME_VERSION=$(chromium-browser --version | awk '{print $2}')
    echo "Chromium Browser バージョン: ${CHROME_VERSION}"
else
    echo "エラー: Chrome/Chromiumが見つかりません。"
    echo "以下のいずれかをインストールしてください:"
    echo "  - Google Chrome"
    echo "  - Chromium"
    exit 1
fi

# メジャーバージョンを取得
CHROME_MAJOR_VERSION=$(echo ${CHROME_VERSION} | cut -d. -f1)
echo "Chromeメジャーバージョン: ${CHROME_MAJOR_VERSION}"

# アーキテクチャを検出
ARCH=$(uname -m)
case "${ARCH}" in
    x86_64)
        PLATFORM="linux64"
        ;;
    aarch64|arm64)
        PLATFORM="linux64"  # ARM版も同じURLパターン
        ;;
    *)
        echo "エラー: 未対応のアーキテクチャ: ${ARCH}"
        exit 1
        ;;
esac

echo "プラットフォーム: ${PLATFORM}"

# ChromeDriverのダウンロードURLを構築
# Chrome for Testing APIから最新のマッチするバージョンを取得
echo ""
echo "対応するChromeDriverのバージョンを検索しています..."

CHROMEDRIVER_VERSION="${CHROME_VERSION}"
DOWNLOAD_URL="https://storage.googleapis.com/chrome-for-testing-public/${CHROMEDRIVER_VERSION}/${PLATFORM}/chromedriver-${PLATFORM}.zip"

echo "ダウンロードURL: ${DOWNLOAD_URL}"

# 一時ディレクトリを作成
TMP_DIR=$(mktemp -d)
trap "rm -rf ${TMP_DIR}" EXIT

# ChromeDriverをダウンロード
echo ""
echo "ChromeDriverをダウンロードしています..."
cd "${TMP_DIR}"

if ! wget -q "${DOWNLOAD_URL}"; then
    echo "エラー: ダウンロードに失敗しました。"
    echo ""
    echo "以下の手順で手動ダウンロードしてください:"
    echo "1. https://googlechromelabs.github.io/chrome-for-testing/#stable にアクセス"
    echo "2. Chrome ${CHROME_MAJOR_VERSION} に対応するChromeDriverを探す"
    echo "3. ${PLATFORM} 版をダウンロード"
    echo "4. 解凍して chromedriver を ${PROJECT_ROOT}/ に配置"
    echo "5. chmod +x ${PROJECT_ROOT}/chromedriver を実行"
    exit 1
fi

echo "ダウンロード完了。解凍しています..."
unzip -q "chromedriver-${PLATFORM}.zip"

# ChromeDriverをプロジェクトルートにコピー
echo "ChromeDriverを配置しています..."
cp "chromedriver-${PLATFORM}/chromedriver" "${CHROMEDRIVER_PATH}"
chmod +x "${CHROMEDRIVER_PATH}"

# バージョン確認
INSTALLED_VERSION=$(${CHROMEDRIVER_PATH} --version | awk '{print $2}')

echo ""
echo "=========================================="
echo "✓ ChromeDriverのセットアップが完了しました"
echo "=========================================="
echo "インストール先: ${CHROMEDRIVER_PATH}"
echo "バージョン: ${INSTALLED_VERSION}"
echo ""
echo "テストを実行するには:"
echo "  ant test"
