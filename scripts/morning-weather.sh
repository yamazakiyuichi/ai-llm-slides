#!/usr/bin/env bash
# 毎朝の天気確認スクリプト
# 場所: 川崎市幸区
# 用途: Claude CLI を使って今日の天気を取得・表示する

set -euo pipefail

LOCATION="${WEATHER_LOCATION:-川崎市幸区}"
LOG_DIR="${WEATHER_LOG_DIR:-$HOME/.weather-logs}"
DATE=$(date +"%Y-%m-%d")
LOG_FILE="$LOG_DIR/weather-$DATE.txt"

mkdir -p "$LOG_DIR"

echo "=== 朝の天気確認: $LOCATION ($DATE) ===" | tee "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Claude CLI で天気確認
# 事前に `claude` コマンドが PATH に入っていること
if ! command -v claude &>/dev/null; then
  echo "エラー: claude コマンドが見つかりません。" >&2
  echo "インストール方法: https://claude.ai/code" >&2
  exit 1
fi

PROMPT="今日（${DATE}）の${LOCATION}の天気を調べて、以下の形式で日本語で簡潔に教えてください：
- 天気概況（晴れ/曇り/雨 など）
- 最高気温・最低気温
- 降水確率
- 風速・風向き
- 一言アドバイス（傘が必要か、服装のヒントなど）"

claude --print "$PROMPT" 2>&1 | tee -a "$LOG_FILE"

echo ""
echo "ログ保存先: $LOG_FILE"
