-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.o.relativenumber = true


vim.opt.cursorline = true

-- Disable mouse mode
vim.o.mouse = ''

-- Enable break indent
vim.o.modeline = true
vim.o.breakindent = true
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
require("catppuccin").setup({
    flavour = "macchiato",
    integrations = {
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
    }
})

vim.cmd.colorscheme "catppuccin"

--vim.cmd()
-- vim.opt.clipboard = 'unnamed,unnamedplus'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Concealer for Neorg
vim.o.conceallevel=2

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disample LSP logs to prevent very large log files
vim.lsp.set_log_level("off")

-- tiny-inline-diagnostics settings, to not have all diagnostics in the buffer displayed
vim.diagnostic.config({ virtual_text = false })
