vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require('plugins.lazy')
require('plugins.lualine')
require('options')
require('keymaps')
require('plugins.gitsigns')
require('plugins.tele')
require('plugins.lsp')
require('plugins.nvimtree')
require('plugins.cmp')


require("notify").setup({ 
  background_colour = "#ff9e64", 
  render = "compact",
  stages = "static",
})


-- vim: ts=8 sts=4 sw=4 et
