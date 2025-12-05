# Playwright E2E テスト実装

## 目的

Playwright を使用した E2E テストを Page Object Model (POM) パターンで設計・実装する。

## 前提条件

**必須**: 実行前に `.cursor/rules/playwright.mdc` を必ず読み込み、ルールに完全準拠すること。

## 入力パラメータ

- `対象ページ/機能`: テスト対象（必須）
- `テストケース`: 実装するテストケース（オプション）

## 実行手順

### 1. ルールファイルの読み込み

```text
.cursor/rules/playwright.mdc を読み込み、以下を確認:
- テスト記述は日本語で直接記述
- Page Object Model (POM) パターンを必須で使用
- describe によるグループ化は共通セットアップ時のみ
- ロールベース・ラベルベースのロケーターを優先
- 外部サービスは必ずモック
```

### 2. 既存の POM 構造を確認

```text
e2e/
├── pages/           # Page Object クラス
├── fixtures/        # カスタムフィクスチャ
└── *.spec.ts        # テストファイル
```

### 3. テストケースの決定

#### テストケースが指定されている場合

→ 指定されたテストケースをそのまま実装

#### テストケースが指定されていない場合

**ブラウザで実際の操作を確認し、理想のユーザーフローからテストを設計**:

1. `mcp_cursor-ide-browser_browser_navigate` で対象ページにアクセス
2. `mcp_cursor-ide-browser_browser_snapshot` でページ構造を取得
3. 以下の観点でユーザーフローを洗い出す:

   - **ハッピーパス**: 理想的なユーザー操作の流れ
   - **ナビゲーション**: ページ遷移、リンク動作
   - **フォーム操作**: 入力、送信、バリデーション
   - **状態変化**: ログイン/ログアウト、データ更新
   - **エラーハンドリング**: 失敗時の表示
   - **レスポンシブ**: モバイル/デスクトップ表示

4. `mcp_cursor-ide-browser_browser_click` や `mcp_cursor-ide-browser_browser_type` で実際に操作を試す
5. 操作結果を `mcp_cursor-ide-browser_browser_snapshot` で確認

### 4. Page Object クラスの作成/更新

#### 新規ページの場合

```typescript
// e2e/pages/[page-name].page.ts
import type { Locator, Page } from "@playwright/test";
import { BasePage } from "./base.page";

export class [PageName]Page extends BasePage {
  // ロケーター定義（ロールベース優先）
  readonly heading: Locator;
  readonly submitButton: Locator;
  readonly emailInput: Locator;

  constructor(page: Page) {
    super(page);
    this.heading = page.getByRole("heading", { level: 1 });
    this.submitButton = page.getByRole("button", { name: /送信|submit/i });
    this.emailInput = page.getByRole("textbox", { name: /メール|email/i });
  }

  // ページ固有のアクション
  async goto() {
    await this.page.goto("/path");
  }

  async submitForm(email: string) {
    await this.emailInput.fill(email);
    await this.submitButton.click();
  }
}
```

#### フィクスチャへの追加

```typescript
// e2e/fixtures/test.ts
import { [PageName]Page } from "../pages/[page-name].page";

type PageFixtures = {
  // 既存のフィクスチャ...
  [pageName]Page: [PageName]Page;
};

export const test = base.extend<PageFixtures>({
  // 既存...
  [pageName]Page: async ({ page }, use) => {
    await use(new [PageName]Page(page));
  },
});
```

### 5. テストファイルの作成

```typescript
// e2e/[feature].spec.ts
import { expect, test } from "./fixtures/test";

// 正常系テスト
test("正常に○○ページが表示される", async ({ [pageName]Page }) => {
  await [pageName]Page.goto();

  await expect([pageName]Page.heading).toBeVisible();
  await expect([pageName]Page.heading).toHaveText("期待するタイトル");
});

// ユーザーフローテスト
test("正常にフォーム送信後に完了画面が表示される", async ({ [pageName]Page, page }) => {
  await [pageName]Page.goto();

  await [pageName]Page.submitForm("test@example.com");

  await expect(page).toHaveURL(/\/complete/);
  await expect(page.getByText("送信が完了しました")).toBeVisible();
});

// 外部リンクのテスト（href属性を検証）
test("正常に外部リンクが正しいURLを持つ", async ({ [pageName]Page }) => {
  await [pageName]Page.goto();

  await expect([pageName]Page.externalLink).toHaveAttribute(
    "href",
    /https:\/\/example\.com/
  );
});

// ナビゲーションテスト
test("正常に○○から△△へ遷移できる", async ({ [pageName]Page, page }) => {
  await [pageName]Page.goto();

  await [pageName]Page.navigateToNext();

  await expect(page).toHaveURL("/next");
});
```

### 6. 外部サービスのモック設定

```typescript
// e2e/fixtures/test.ts
export const test = base.extend({
  // 外部APIをモック
  mockExternalApis: [
    async ({ page }, use) => {
      // 認証サービスをモック
      await page.route("**/api.external-service.com/**", (route) => {
        route.fulfill({
          status: 200,
          contentType: "application/json",
          body: JSON.stringify({ success: true }),
        });
      });

      // アナリティクスをブロック
      await page.route("**/analytics.google.com/**", (route) => route.abort());

      await use();
    },
    { auto: true },
  ],
});
```

### 7. テスト実行と検証

```bash
# UIモードで確認（推奨）
npm run test:e2e:ui

# 特定のテストのみ
npx playwright test [feature].spec.ts

# 全ブラウザで実行
npx playwright test --project=chromium --project=firefox --project=webkit
```

### 8. フォーマット

```bash
npm run format
```

## テストケース設計のチェックリスト

### ページ表示テスト

- [ ] 正常にページが表示される
- [ ] 必要な要素が全て表示される
- [ ] ヘッダー/フッターが表示される
- [ ] 国際化（日本語/英語）が正しく表示される

### ナビゲーションテスト

- [ ] 内部リンクで正しく遷移する
- [ ] 外部リンクが正しい URL を持つ（href 属性検証）
- [ ] 戻る操作が正しく動作する

### フォームテスト

- [ ] 正常入力で送信が成功する
- [ ] バリデーションエラーが表示される
- [ ] 必須項目が未入力で送信できない

### ユーザーフローテスト

- [ ] ハッピーパスが完了する
- [ ] エラー時に適切なメッセージが表示される
- [ ] ローディング状態が表示される

### レスポンシブテスト

- [ ] デスクトップ表示が正しい
- [ ] モバイル表示が正しい

## 制約条件

- **テスト記述は日本語**で直接記述（test("正常に〇〇される", ...)）
- **Page Object Model (POM) を必須で使用**
- **外部サービスは必ずモック**（認証、決済、アナリティクス等）
- **ロールベースのロケーターを優先**（getByRole > getByLabel > getByText > getByTestId）
- **外部リンクは href 属性を検証**（実際の遷移はしない）
- **test.only / test.skip はコミットしない**
- **ハードコードされた待機時間は使用しない**（page.waitForTimeout 禁止）

## ファイル構成

```text
e2e/
├── pages/                    # Page Object Model クラス
│   ├── base.page.ts          # 共通のベースページ
│   └── [page-name].page.ts   # 各ページのPOM
├── fixtures/
│   └── test.ts               # カスタムフィクスチャ（POM含む）
└── [feature].spec.ts         # テストファイル
```

## 出力形式

- 全てのテストコードは日本語で記述
- POM クラスは `e2e/pages/` に配置
- テストファイルは `e2e/` 直下に配置
- 実装完了後、テスト実行結果を報告
