local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim を追加してプラグインを取り込みます
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- 自分のプラグインを読み込んだり上書きしたりできます
    { import = "plugins" },
  },
  defaults = {
    -- デフォルトでは LazyVim のプラグインだけが遅延読み込みされます。自作プラグインは起動時に読み込まれます。
    -- 意図がある場合はこれを `true` にして、自作プラグインもデフォルトで遅延読み込みできます。
    lazy = false,
    -- バージョン管理に対応した多くのプラグインはリリースが古く、Neovim の環境を壊す恐れがあるため、当面は version=false のままにすることを推奨します。
    version = false, -- 常に最新の git コミットを使用
    -- version = "*", -- semver に対応するプラグインでは、最新の安定版のインストールを試みます
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- プラグイン更新を定期的にチェック
    notify = false, -- 更新を通知するか
  }, -- プラグイン更新を自動で確認
  performance = {
    rtp = {
      -- いくつかの rtp プラグインを無効化
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
