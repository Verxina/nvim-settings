-- これはサンプルの spec なので、実際には何も読み込まず空の spec を返します
-- stylua: ignore
if true then return {} end

-- "plugins" ディレクトリ配下の各 spec ファイルは lazy.nvim によって自動で読み込まれます
--
-- プラグインファイルでは次のことができます:
-- * 追加のプラグインを入れる
-- * LazyVim のプラグインを無効化/有効化する
-- * LazyVim プラグインの設定を上書きする
return {
  -- gruvbox を追加
  { "ellisonleao/gruvbox.nvim" },

  -- LazyVim が gruvbox を読み込むよう設定
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  -- trouble の設定を変更
  {
    "folke/trouble.nvim",
    -- opts は親の spec とマージされます
    opts = { use_diagnostic_signs = true },
  },

  -- trouble を無効化
  { "folke/trouble.nvim", enabled = false },

  -- nvim-cmp を上書きして cmp-emoji を追加
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- telescope の一部オプションとプラグインファイルを探すキーマップを変更
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- プラグインファイルを探すキーマップを追加
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- いくつかのオプションを変更
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- lspconfig に pyright を追加
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright は mason で自動インストールされ、lspconfig で読み込まれます
        pyright = {},
      },
    },
  },

  -- tsserver を追加し、lspconfig の代わりに typescript.nvim で設定
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- tsserver は mason で自動インストールされ、lspconfig で読み込まれます
        tsserver = {},
      },
      -- ここで追加の LSP サーバー設定を行えます
      -- lspconfig でこのサーバーを設定したくない場合は true を返します
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- typescript.nvim で設定する例
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
        -- 任意のサーバーのフォールバックとして使うには * を指定します
        -- ["*"] = function(server, opts) end,
      },
    },
  },

  -- TypeScript 用には、lspconfig・treesitter・mason・typescript.nvim を正しくセットアップするための追加 spec も LazyVim に含まれています。
  -- そのため、上記の代わりに次の設定を使えます:
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- treesitter のパーサーをさらに追加
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- `vim.tbl_deep_extend` はリストではなくテーブルだけをマージできるため、上のコードは
  -- `ensure_installed` を新しい値で上書きしてしまいます。
  -- デフォルト設定を拡張したい場合は、代わりに下のコードを使ってください:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- tsx と typescript を追加
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
    end,
  },

  -- opts 関数でデフォルトのオプションも変更できます:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, {
        function()
          return "😄"
        end,
      })
    end,
  },

  -- あるいは新しいオプションを返して全てのデフォルトを上書きできます
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[ここにカスタムの lualine 設定を追加してください]]
      }
    end,
  },

  -- alpha の代わりに mini.starter を使用
  { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- jsonls と schemastore のパッケージを追加し、json・json5・jsonc 用の treesitter を設定
  { import = "lazyvim.plugins.extras.lang.json" },

  -- インストールしておきたいツールをここに追加
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
  },
}
