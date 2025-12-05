return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        -- 保存時の "X行、X文字" メッセージを小さく表示
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        -- "No information available" を非表示
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = true,         -- 検索を下部に
        command_palette = true,        -- コマンドパレット有効
        long_message_to_split = true,  -- 長いメッセージを分割
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "最後のメッセージ" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "メッセージ履歴" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "全メッセージ" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "メッセージ消去" },
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "コマンドリダイレクト" },
    },
  },
  
  -- nvim-notify設定（メッセージ表示時間延長）
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,  -- 5秒表示
      background_colour = "#000000",
    },
  },
}
