-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Shade everything past the project's max line length.
-- Neovim's builtin EditorConfig support sets 'textwidth' from `max_line_length`,
-- so this picks up e.g. the 90 columns configured in ml-dev/.editorconfig.
-- 'colorcolumn' takes a list of columns, so a range highlights a whole region
-- with the ColorColumn group rather than drawing a single ruler line.
local MAX_COL = 400
local overflow_cache = {}

---@param textwidth integer
local function overflow_columns(textwidth)
  if textwidth <= 0 or textwidth >= MAX_COL then
    return ""
  end
  if not overflow_cache[textwidth] then
    local cols = {}
    for c = textwidth + 1, MAX_COL do
      cols[#cols + 1] = c
    end
    overflow_cache[textwidth] = table.concat(cols, ",")
  end
  return overflow_cache[textwidth]
end

local function shade_overflow()
  vim.opt_local.colorcolumn = overflow_columns(vim.bo.textwidth)
end

local shade_group = vim.api.nvim_create_augroup("shade_past_textwidth", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = shade_group,
  callback = shade_overflow,
})

-- EditorConfig and filetype plugins set 'textwidth' after the window is entered.
vim.api.nvim_create_autocmd("OptionSet", {
  group = shade_group,
  pattern = "textwidth",
  callback = shade_overflow,
})
