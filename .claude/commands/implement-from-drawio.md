# Draw.io 設計図からの実装

指定された Draw.io ファイル（.drawio）を解析し、その設計フローに従ってコードを実装・修正する。最後に設計図通りに実装されているか自己レビューを実施する。

## 使用方法

/implement-from-drawio [drawio ファイルパス]

例：

- /implement-from-drawio dev-docs/gitlab-ci/gitlab-ci-flow.drawio
- /implement-from-drawio dev-docs/commands/make-run-flow.drawio

## 処理手順

### フェーズ 1: 設計図の解析

- Draw.io ファイルを読み込み、XML 構造を解析
- タイトル、スイムレーン、ノード、エッジ、凡例を抽出
- フロー構造を構築

### フェーズ 2: コミット履歴の確認

- git log で対象 drawio ファイルの履歴を取得
- 最近の変更点を把握

### フェーズ 3: 実装対象の特定

- drawio の内容から実装対象ファイルを特定
- 現状コードと drawio の差分を把握

### フェーズ 4: 実装

- drawio の設計を厳密に再現
- 処理の順序は drawio のフローに従う
- 条件分岐の Yes/No パスは drawio 通りに実装

### フェーズ 5: 自己レビュー

- 設計図との照合チェックを実施
- 不一致がないか確認

## 注意事項

### 必須

- drawio を正として実装すること（コードの都合で drawio を変えない）
- 自己レビューをスキップしないこと

### 禁止

- drawio にない独自の処理を追加すること
- drawio の条件分岐を勝手に変更すること
