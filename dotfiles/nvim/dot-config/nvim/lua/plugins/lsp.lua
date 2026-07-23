return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Disable defualt virtual text diagnostics
      diagnostics = {
        virtual_text = false,
      },
      servers = {
        ["*"] = {
          keys = {
            -- Disable LazyVim default's hover keymap
            { "K", false },
            -- Hover on <leader>i
            -- Capability-based keymap (only set if server supports it)
            { "<leader>i", vim.lsp.buf.hover, desc = "Hover" },
          },
        },
      },
    },
  },
  -- Add inline diagnostics when you hover over a line with a diagnostic
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {},
  },
}
