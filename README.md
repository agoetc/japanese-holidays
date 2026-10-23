# japanese-holidays

日本の国民の祝日・休日データ（内閣府公開データの UTF-8 変換版）。

- 配信 URL: https://agoetc.github.io/japanese-holidays/holidays.csv
- 出典: [内閣府「国民の祝日」について](https://www8.cao.go.jp/chosei/shukujitsu/gaiyou.html)（`syukujitsu.csv`）
- 更新: GitHub Actions が毎月1日に取得してコミット（確認日は `docs/last-checked.txt`。変更がない月もコミットするのは、60日間活動のないリポジトリの定期実行を GitHub が止めるため）

## フォーマット

UTF-8 / LF。1行目はヘッダー、以降 `YYYY/M/D,名称`。

```
国民の祝日・休日月日,国民の祝日・休日名称
1955/1/1,元日
```
