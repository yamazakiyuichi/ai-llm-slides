#!/usr/bin/env bash
# morning-weather.sh を毎朝6時に実行する cron ジョブを登録するスクリプト

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WEATHER_SCRIPT="$SCRIPT_DIR/morning-weather.sh"

if [ ! -f "$WEATHER_SCRIPT" ]; then
  echo "エラー: $WEATHER_SCRIPT が見つかりません。" >&2
  exit 1
fi

chmod +x "$WEATHER_SCRIPT"

# 既存の cron エントリを確認（重複登録を防ぐ）
CRON_ENTRY="0 6 * * * $WEATHER_SCRIPT >> \$HOME/.weather-logs/cron.log 2>&1"

if crontab -l 2>/dev/null | grep -qF "$WEATHER_SCRIPT"; then
  echo "既に cron ジョブが登録されています："
  crontab -l | grep "$WEATHER_SCRIPT"
  echo ""
  echo "再登録する場合は既存エントリを削除してから再実行してください："
  echo "  crontab -e"
  exit 0
fi

# cron に追加
(crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -

echo "cron ジョブを登録しました！"
echo ""
echo "設定内容:"
echo "  時刻: 毎日 朝6時"
echo "  実行スクリプト: $WEATHER_SCRIPT"
echo "  場所: 川崎市幸区（WEATHER_LOCATION 環境変数で変更可）"
echo "  ログ: \$HOME/.weather-logs/cron.log"
echo ""
echo "確認コマンド: crontab -l"
echo "削除コマンド: crontab -e  (該当行を削除)"
echo ""
echo "場所を変更する場合は crontab -e で以下のように編集してください："
echo "  0 6 * * * WEATHER_LOCATION=横浜市 $WEATHER_SCRIPT >> \$HOME/.weather-logs/cron.log 2>&1"
