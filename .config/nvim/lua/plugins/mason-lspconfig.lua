-- ~/.config/nvim/lua/plugins/mason-lspconfig.lua
return {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  config = function()
    local lsp_servers = { "lua_ls", "pyright", "ruff", "ts_ls", "html", "yamlls", "jsonls", "typos_lsp" }
    
    require("mason-lspconfig").setup {
      ensure_installed = lsp_servers,
      automatic_enable = true,  -- v2の新機能：自動有効化
    }
    
    -- 個別設定は `vim.lsp.config()` または lspconfigで直接設定
    local lspconfig = require("lspconfig")
    
    lspconfig.pyright.setup {
      root_dir = lspconfig.util.root_pattern(".venv"),
      settings = {
        python = {
          venvPath = ".",
          pythonPath = "./.venv/bin/python",
        }
      }
    }
    
    lspconfig.typos_lsp.setup {}
    
    -- キーマップ設定
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    vim.keymap.set('n', 'gt', '<C-t>')
    vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  end,
}
