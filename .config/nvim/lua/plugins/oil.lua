return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      columns = { "icon" },
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["q"] = "actions.close",
        ["<C-c>"] = "actions.close",
        ["<CR>"] = "actions.select",
        ["-"] = "actions.parent",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-r>"] = "actions.refresh",
        ["g?"] = "actions.show_help",
      },
    })
    -- キーマップ
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil: 親ディレクトリ" })
  end,
}
