-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("i", "jk", "<Esc>", { noremap = false })

vim.keymap.set({ "n", "v" }, "J", "5j", { noremap = false })
vim.keymap.set({ "n", "v" }, "K", "5k", { noremap = false })

-- Open the current buffer's file with the macOS default app (e.g. Preview for PDFs).
vim.keymap.set("n", "<leader>fo", "<cmd>!open %<CR>", { silent = true, desc = "Open file in native app" })

-- Run AvanteEdit on visual selection. Discarding since we are relying in claude-code extension now.
-- vim.keymap.set("v", "<leader>ae", ":AvanteEdit<CR>", { desc = "Edit Avante" })

-- keymaps for Obsidian (if the environment variable is set)
local function check_obsidian_workspace()
  local obsidian_workspace_path = vim.env.OBSIDIAN_WORKSPACE_PATH
  if not obsidian_workspace_path or obsidian_workspace_path == "" then
    vim.notify(
      "Environment variable 'OBSIDIAN_WORKSPACE_PATH' is not set or is empty.\n"
        .. "Set it to a valid Vault path to enable Obsidian support.",
      vim.log.levels.WARN
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
end, { silent = true, desc = "Open yesterday's note" })

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

vim.keymap.set("n", "<leader>oo", function()
  if check_obsidian_workspace() then
    vim.cmd("ObsidianOpen")
  end
end, { silent = true, desc = "Open in Obsidian" })
