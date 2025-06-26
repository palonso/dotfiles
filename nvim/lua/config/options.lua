-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Deactivate mouse support
vim.opt.mouse = ""

-- Do not provide ai suggestions as completion entries
vim.g.ai_cmp = false

-- Disable line wrap
vim.opt.wrap = true

-- Support copying to system's buffer from remote servers (OSC 52) also inside tmux sessions
-- https://github.com/neovim/neovim/discussions/29350#discussioncomment-10299517
vim.opt.clipboard = "unnamedplus"

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
if vim.env.TMUX ~= nil then
  local copy = { "tmux", "load-buffer", "-w", "-" }
  local paste = { "bash", "-c", "tmux refresh-client -l && sleep 0.05 && tmux save-buffer -" }
  vim.g.clipboard = {
    name = "tmux",
    copy = {
      ["+"] = copy,
      ["*"] = copy,
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
    cache_enabled = 0,
  }
end
