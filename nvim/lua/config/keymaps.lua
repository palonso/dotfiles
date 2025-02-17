-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<Esc>", { noremap = false })

vim.keymap.set({ "n", "v" }, "J", "5j", { noremap = false })
vim.keymap.set({ "n", "v" }, "K", "5k", { noremap = false })

-- keymaps for Obsidian (if the environment variable is set)
local function check_obsidian_workspace()
  local obsidian_workspace_path = vim.env.OBSIDIAN_WORKSPACE_PATH
  if not obsidian_workspace_path or obsidian_workspace_path == "" then
    vim.api.nvim_err_writeln(
      "Environment variable 'OBSIDIAN_WORKSPACE_PATH' is not set or is empty. "
        .. "Set it to a valid Vault path to enable Obsidian support."
    )
    return false
  end
  return true
end

vim.keymap.set("n", "<leader>ot", function()
  if check_obsidian_workspace() then
    vim.cmd("ObsidianToday")
  end
end, { silent = true, desc = "Open today's note" })

vim.keymap.set("n", "<leader>oy", function()
  if check_obsidian_workspace() then
    vim.cmd("ObsidianYesterday")
  end
end, { silent = true })

vim.keymap.set("n", "<leader>om", function()
  if check_obsidian_workspace() then
    vim.cmd("ObsidianTomorrow")
  end
end, { silent = true, desc = "Open tomorrow's note" })

vim.keymap.set("n", "<leader>od", function()
  if check_obsidian_workspace() then
    vim.cmd("ObsidianDailies")
  end
end, { silent = true, desc = "Open daily notes" })

vim.keymap.set("n", "<leader>on", function()
  if check_obsidian_workspace() then
    vim.cmd("ObsidianNew")
  end
end, { silent = true, desc = "Create a new note" })

vim.keymap.set("n", "<leader>so", function()
  if check_obsidian_workspace() then
    vim.cmd("ObsidianSearch")
  end
end, { silent = true, desc = "Search notes" })
