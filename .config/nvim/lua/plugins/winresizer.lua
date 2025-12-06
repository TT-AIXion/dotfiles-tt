return {
  "simeji/winresizer",
  event = "WinNew", -- 新しいウィンドウを開いた時などに読み込む（遅延ロード）
  init = function()
    -- デフォルトの起動キーは <C-e> です
    -- 変更したい場合は以下をコメントアウトして設定してください
    -- vim.g.winresizer_start_key = '<C-w>e' 
    
    -- リサイズ幅の設定（任意）
    vim.g.winresizer_vert_resize = 10 -- 垂直リサイズ幅
    vim.g.winresizer_horiz_resize = 3  -- 水平リサイズ幅
  end,
}
