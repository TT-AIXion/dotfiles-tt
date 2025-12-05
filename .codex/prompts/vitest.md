# Vitest ユニット/コンポーネントテスト実装

## 目的

Vitest を使用したユニットテスト・コンポーネントテストを設計・実装する。

## 前提条件

**必須**: 実行前に `.cursor/rules/vitest.mdc` を必ず読み込み、ルールに完全準拠すること。

## 入力パラメータ

- `対象ファイル/コンポーネント`: テスト対象（必須）
- `テストケース`: 実装するテストケース（オプション）

## 実行手順

### 1. ルールファイルの読み込み

```text
.cursor/rules/vitest.mdc を読み込み、以下を確認:
- テスト記述は日本語で直接記述
- describe によるグループ化は最小限
- POM パターンは不要（Vitest はユニット/コンポーネント用）
- ロールベース・ラベルベースのロケーターを優先
- 外部依存は必ずモック
```

### 2. テスト対象の分析

1. 対象ファイルを読み込む
2. 以下を特定:
   - コンポーネント/関数の責務
   - props/引数の型と制約
   - 状態管理の有無
   - 外部依存（API、ライブラリ）
   - エッジケース

### 3. テストケースの決定

#### テストケースが指定されている場合

→ 指定されたテストケースをそのまま実装

#### テストケースが指定されていない場合

**ブラウザで動作確認を行い、理想の操作フローからテストを設計**:

1. `mcp_cursor-ide-browser_browser_navigate` で対象ページにアクセス
2. `mcp_cursor-ide-browser_browser_snapshot` でページ構造を取得
3. 以下の観点でテストケースを洗い出す:
   - **正常系**: 期待通りの動作
   - **異常系**: エラー時の動作
   - **境界値**: 最小/最大/空の入力
   - **a11y**: キーボード操作、ARIA 属性、フォーカス管理
   - **状態変化**: ユーザー操作による状態遷移

### 4. テストファイルの作成

```text
配置ルール:
- src/components/Button.tsx → src/components/Button.test.tsx
- src/lib/utils.ts → src/lib/utils.test.ts
```

### 5. テスト実装

以下のパターンに従って実装:

```typescript
import { expect, test, vi } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

// 外部依存のモック（必須）
vi.mock(import("@/lib/api"), () => ({
  fetchData: vi.fn(),
}));

// 正常系テスト
test("正常に○○が表示される", () => {
  render(<Component />);
  expect(screen.getByRole("button")).toBeInTheDocument();
});

// ユーザー操作テスト
test("クリック時に○○が実行される", async () => {
  const user = userEvent.setup();
  const handleClick = vi.fn();
  render(<Component onClick={handleClick} />);

  await user.click(screen.getByRole("button"));

  expect(handleClick).toHaveBeenCalledOnce();
});

// キーボード操作テスト（a11y）
test("正常にEnterキーで○○が実行される", async () => {
  const user = userEvent.setup();
  render(<Component />);

  await user.keyboard("{Enter}");

  expect(...).toBe(...);
});

// エラー系テスト
test("エラー時に○○が表示される", async () => {
  vi.mocked(fetchData).mockRejectedValue(new Error("エラー"));
  render(<Component />);

  await expect(screen.findByText("エラーが発生しました")).resolves.toBeVisible();
});
```

### 6. テスト実行と検証

```bash
npm run test:unit -- [テストファイル名]
```

- 全テストがパスすることを確認
- カバレッジが適切であることを確認

### 7. フォーマット

```bash
npm run format
```

## テストケース設計のチェックリスト

### コンポーネントテスト

- [ ] 正常にレンダリングされる
- [ ] props が正しく反映される
- [ ] ユーザー操作（クリック、入力）が動作する
- [ ] 条件付きレンダリングが正しく動作する
- [ ] ローディング状態が表示される
- [ ] エラー状態が表示される
- [ ] キーボード操作が可能（a11y）
- [ ] ARIA 属性が正しく設定される（a11y）
- [ ] フォーカス管理が適切（a11y）

### ユーティリティ関数テスト

- [ ] 正常な入力で期待する出力を返す
- [ ] 境界値（空、最小、最大）で正しく動作する
- [ ] 不正な入力でエラーをスローする
- [ ] 非同期処理が正しく完了する

## 制約条件

- **テスト記述は日本語**で直接記述（test("正常に〇〇される", ...)）
- **describe によるグループ化は最小限**（並列実行やスコープ設定時のみ）
- **外部 API/サービスは必ずモック**
- **ロールベースの取得を優先**（getByRole > getByLabel > getByText > getByTestId）
- **test.only / test.skip はコミットしない**
- **any 型は使用しない**

## 出力形式

- 全てのテストコードは日本語コメント付き
- テストファイル名: `[対象ファイル名].test.tsx` または `.test.ts`
- 実装完了後、テスト実行結果を報告
