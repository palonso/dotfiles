vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require('options')
require('plugins.lazy')
require('plugins.lualine')
require('keymaps')
require('plugins.gitsigns')
require('plugins.tele')
require('plugins.nvimtree')
require('plugins.lsp')
require('plugins.cmp')

require("notify").setup({ 
  background_colour = "#ff9e64", 
  render = "compact",
  stages = "static",
})


-- vim: ts=2 sw=2 et
