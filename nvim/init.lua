require('options')

require('plugins.lazy')
require('plugins.mini')
require('plugins.lualine')
require('plugins.gitsigns')
require('plugins.tele')
require('plugins.nvimtree')
require('plugins.lsp')
require('plugins.cmp')

require('keymaps')

require("notify").setup({ 
  background_colour = "#ff9e64", 
  render = "compact",
  stages = "static",
})


-- vim: ts=2 sw=2 et
