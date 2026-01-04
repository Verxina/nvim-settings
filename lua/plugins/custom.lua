return {
  "levouh/tint.nvim",
  {
    "romgrk/barbar.nvim",
    event = "VimEnter",
    config = function()
      -- Move to previous/next
      vim.keymap.set("n", "<S-h>", "<Cmd>BufferPrevious<CR>", { desc = "Prev buffer" })
      vim.keymap.set("n", "<S-l>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      -- get nvim-tree api
      local api = require("nvim-tree.api")

      -- custom on_attach function to create buffer-local keymaps
      local on_attach = function(bufnr)
        -- default mappings
        api.config.mappings.default_on_attach(bufnr)
        -- custom buffer-local mapping
        vim.keymap.set(
          "n",
          "<C-e>",
          api.tree.toggle,
          { buffer = bufnr, noremap = true, silent = true, desc = "Toggle nvim-tree" }
        )
      end

      -- setup nvim-tree
      require("nvim-tree").setup({
        on_attach = on_attach,
      })

      -- global mapping for all other buffers
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

      -- Set keymap to toggle terminal in normal mode
      vim.keymap.set("n", "<C-t>", "<cmd>ToggleTerm<cr>", {
        noremap = true,
        silent = true,
        desc = "Toggle terminal",
      })

      -- Helper function for terminal keymaps
      local function set_terminal_keymaps()
        -- buffer-local keymaps for the terminal
        local opts = { buffer = 0 }
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
        vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
        vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
        vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
        vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
      end

      -- Apply keymaps when a terminal is opened
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*",
        callback = function()
          set_terminal_keymaps()
        end,
      })
    end,
  },

  -- Disable the default bufferline plugin to avoid conflicts
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },

  -- Add Copilot
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
