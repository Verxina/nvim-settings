return {
  "levouh/tint.nvim",
  {
    "romgrk/barbar.nvim",
    event = "VimEnter",
    config = function()
      -- 前/次のバッファへ移動
      vim.keymap.set("n", "<S-h>", "<Cmd>BufferPrevious<CR>", { desc = "Prev buffer" })
      vim.keymap.set("n", "<S-l>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      -- nvim-tree の API を取得
      local api = require("nvim-tree.api")

      -- バッファローカルなキーマップを作る on_attach のカスタム関数
      local on_attach = function(bufnr)
        -- デフォルトのマッピング
        api.config.mappings.default_on_attach(bufnr)
        -- カスタムのバッファローカルマッピング
        vim.keymap.set(
          "n",
          "<C-e>",
          api.tree.toggle,
          { buffer = bufnr, noremap = true, silent = true, desc = "Toggle nvim-tree" }
        )
      end

      -- nvim-tree を設定
      require("nvim-tree").setup({
        on_attach = on_attach,
      })

      -- 他のすべてのバッファ用のグローバルマッピング
      vim.keymap.set("n", "<C-e>", "<cmd>NvimTreeToggle<cr>", {
        noremap = true,
        silent = true,
        desc = "Toggle nvim-tree",
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup()

      -- ノーマルモードでターミナルをトグルするキーマップを設定
      vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<cr>", {
        noremap = true,
        silent = true,
        desc = "Toggle terminal",
      })

      -- ターミナル用キーマップのヘルパー関数
      local function set_terminal_keymaps()
        -- ターミナル用のバッファローカルなキーマップ
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
      end

      -- ターミナルが開かれたときにキーマップを適用
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
          set_terminal_keymaps()
        end,
      })
    end,
  },

  -- 競合を避けるためデフォルトの bufferline プラグインを無効化
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  -- Copilot を追加
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter",
  },
  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    config = function()
        require("CopilotChat").setup()
        vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChat<CR>", { desc = "CopilotChat: Toggle" })
    end,
  },
}
