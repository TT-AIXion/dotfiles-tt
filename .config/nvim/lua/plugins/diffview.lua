return {
  "sindrets/diffview.nvim",
  config = function()
    local actions = require("diffview.actions")

    require("diffview").setup({
      diff_binaries = false,
      enhanced_diff_hl = false,
      git_cmd = { "git" },
      hg_cmd = { "hg" },
      use_icons = true,
      show_help_hints = true,
      watch_index = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = false,
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = false,
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {},
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
          hg = {
            single_file = {},
            multi_file = {},
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
      },
      commit_log_panel = {
        win_config = {},
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {},
      keymaps = {
        disable_defaults = false,
        view = {
          -- デフォルトの競合キーを無効化
          { "n", "<leader>e", false },
          { "n", "<leader>b", false },
          
          -- 基本操作
          { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
          { "n", "<leader>df", actions.toggle_files, { desc = "Toggle file panel" } },
          
          -- レイアウト
          { "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle available layouts" } },
          
          -- コンフリクト解決
          { "n", "[x", actions.prev_conflict, { desc = "Go to the previous conflict" } },
          { "n", "]x", actions.next_conflict, { desc = "Go to the next conflict" } },
          { "n", "<leader>co", actions.conflict_choose("ours"), { desc = "Choose the OURS version" } },
          { "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose the THEIRS version" } },
          { "n", "<leader>cb", actions.conflict_choose("base"), { desc = "Choose the BASE version" } },
          { "n", "<leader>ca", actions.conflict_choose("all"), { desc = "Choose all versions" } },
          { "n", "dx", actions.conflict_choose("none"), { desc = "Delete the conflict region" } },
          { "n", "<leader>cO", actions.conflict_choose_all("ours"), { desc = "Choose OURS for all conflicts" } },
          { "n", "<leader>cT", actions.conflict_choose_all("theirs"), { desc = "Choose THEIRS for all conflicts" } },
          { "n", "<leader>cB", actions.conflict_choose_all("base"), { desc = "Choose BASE for all conflicts" } },
          { "n", "<leader>cA", actions.conflict_choose_all("all"), { desc = "Choose all versions for all conflicts" } },
          { "n", "dX", actions.conflict_choose_all("none"), { desc = "Delete all conflict regions" } },
          
          -- ヘルプ
          { "n", "g?", actions.help("view"), { desc = "Open the help panel" } },
        },
        file_panel = {
          -- デフォルトの競合キーを無効化
          { "n", "<leader>e", false },
          { "n", "<leader>b", false },
          
          -- ナビゲーション
          { "n", "j", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
          { "n", "<down>", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
          { "n", "k", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
          { "n", "<up>", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
          { "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
          { "n", "o", actions.select_entry, { desc = "Open the diff for the selected entry" } },
          { "n", "l", actions.select_entry, { desc = "Open the diff for the selected entry" } },
          { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
          
          -- ステージング
          { "n", "-", actions.toggle_stage_entry, { desc = "Stage/unstage the selected entry" } },
          { "n", "S", actions.stage_all, { desc = "Stage all entries" } },
          { "n", "U", actions.unstage_all, { desc = "Unstage all entries" } },
          { "n", "X", actions.restore_entry, { desc = "Restore entry to the state on the left side" } },
          
          -- フォールド
          { "n", "zo", actions.open_fold, { desc = "Expand fold" } },
          { "n", "h", actions.close_fold, { desc = "Collapse fold" } },
          { "n", "zc", actions.close_fold, { desc = "Collapse fold" } },
          { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
          { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
          { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
          
          -- スクロール
          { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
          { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
          
          -- ファイル移動
          { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
          { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
          
          -- ファイルを開く
          { "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },
          { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
          { "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
          
          -- 表示切替
          { "n", "i", actions.listing_style, { desc = "Toggle between 'list' and 'tree' views" } },
          { "n", "f", actions.toggle_flatten_dirs, { desc = "Flatten empty subdirectories in tree listing style" } },
          { "n", "R", actions.refresh_files, { desc = "Update stats and entries in the file list" } },
          
          -- パネル操作
          { "n", "<leader>df", actions.toggle_files, { desc = "Toggle the file panel" } },
          { "n", "L", actions.open_commit_log, { desc = "Open the commit log panel" } },
          
          -- レイアウト
          { "n", "g<C-x>", actions.cycle_layout, { desc = "Cycle available layouts" } },
          
          -- コンフリクト解決
          { "n", "[x", actions.prev_conflict, { desc = "Go to the previous conflict" } },
          { "n", "]x", actions.next_conflict, { desc = "Go to the next conflict" } },
          { "n", "<leader>cO", actions.conflict_choose_all("ours"), { desc = "Choose OURS for all conflicts" } },
          { "n", "<leader>cT", actions.conflict_choose_all("theirs"), { desc = "Choose THEIRS for all conflicts" } },
          { "n", "<leader>cB", actions.conflict_choose_all("base"), { desc = "Choose BASE for all conflicts" } },
          { "n", "<leader>cA", actions.conflict_choose_all("all"), { desc = "Choose all versions for all conflicts" } },
          
          -- ヘルプ
          { "n", "g?", actions.help("file_panel"), { desc = "Open the help panel" } },
          
          -- 閉じる
          { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
        },
        file_history_panel = {
          -- ナビゲーション
          { "n", "j", actions.next_entry, { desc = "Next entry" } },
          { "n", "k", actions.prev_entry, { desc = "Prev entry" } },
          { "n", "<cr>", actions.select_entry, { desc = "Select commit" } },
          { "n", "o", actions.select_entry, { desc = "Select commit" } },
          { "n", "<tab>", actions.select_next_entry, { desc = "Next entry & select" } },
          { "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev entry & select" } },
          
          -- コミット操作
          { "n", "y", actions.copy_hash, { desc = "Copy commit hash" } },
          { "n", "L", actions.open_commit_log, { desc = "Open commit details" } },
          
          -- フォールド
          { "n", "zR", actions.open_all_folds, { desc = "Open all folds" } },
          { "n", "zM", actions.close_all_folds, { desc = "Close all folds" } },
          
          -- ヘルプ
          { "n", "g?", actions.help("file_history_panel"), { desc = "Open help" } },
          
          -- 閉じる
          { "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
        },
        option_panel = {
          { "n", "q", actions.close, { desc = "Close panel" } },
          { "n", "<cr>", actions.select_entry, { desc = "Change option" } },
          { "n", "g?", actions.help("option_panel"), { desc = "Open help" } },
        },
        help_panel = {
          { "n", "q", actions.close, { desc = "Close help" } },
          { "n", "<esc>", actions.close, { desc = "Close help" } },
        },
      },
    })
  end,
  
  -- グローバルキーマップ
  keys = {
    -- 基本操作
    { "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Diffview: Open" },
    { "<leader>gc", "<Cmd>DiffviewClose<CR>", desc = "Diffview: Close" },
    
    -- 履歴表示 (snacksと競合しないよう配置)
    { "<leader>gh", "<Cmd>DiffviewFileHistory<CR>", desc = "Diffview: Repo history" },
    { "<leader>gf", "<Cmd>DiffviewFileHistory --follow %<CR>", desc = "Diffview: File history" },
    { "<leader>gl", "<Cmd>.DiffviewFileHistory --follow<CR>", desc = "Diffview: Line history" },
    
    -- ブランチ比較
    { "<leader>gm", "<Cmd>DiffviewOpen main<CR>", desc = "Diffview: vs main" },
    { "<leader>go", "<Cmd>DiffviewOpen origin/main<CR>", desc = "Diffview: vs origin/main" },
    
    -- トグル
    {
      "<leader>gt",
      function()
        local lib = require("diffview.lib")
        local view = lib.get_current_view()
        if view then
          vim.cmd("DiffviewClose")
        else
          vim.cmd("DiffviewOpen")
        end
      end,
      desc = "Diffview: Toggle"
    },
    
    -- Visual mode: 選択範囲の履歴
    {
      "<leader>gh",
      ":'<,'>DiffviewFileHistory --follow<CR>",
      mode = "v",
      desc = "Diffview: Selection history"
    },
  },
}
