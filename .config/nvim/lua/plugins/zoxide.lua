return {
  "jvgrootveld/telescope-zoxide",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    { "<leader>z", "<cmd>Telescope zoxide list<cr>", desc = "Zoxide list" },
    { "<leader>cd", "<cmd>Telescope zoxide list<cr>", desc = "Change directory (zoxide)" },
  },
  config = function()
    local t = require("telescope")
    local z_utils = require("telescope._extensions.zoxide.utils")

    t.setup({
      extensions = {
        zoxide = {
          mappings = {
            ["<C-s>"] = { action = z_utils.create_basic_command("split") },
            ["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
          },
        },
      },
    })

    t.load_extension("zoxide")
  end,
}
