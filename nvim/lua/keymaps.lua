vim.api.nvim_set_keymap("i", "jk", "<Esc>", {noremap=false})
-- twilight
-- vim.api.nvim_set_keymap("n", "tw", ":Twilight<enter>", {noremap=false})
-- buffers
vim.api.nvim_set_keymap("n", "<C-k>", ":blast<cr>", {noremap=false, silent=true})
vim.api.nvim_set_keymap("n", "<C-j>", ":bfirst<cr>", {noremap=false, silent=true})
vim.api.nvim_set_keymap("n", "<C-h>", ":bprev<cr>", {noremap=false, silent=true})
vim.api.nvim_set_keymap("n", "<C-l>", ":bnext<cr>", {noremap=false, silent=true})
vim.api.nvim_set_keymap("n", "<leader>d", ":bdelete<cr>", {noremap=false, silent=true})
vim.api.nvim_set_keymap("n", "<leader>D", ":bdelete!<cr>", {noremap=false, silent=true})
vim.api.nvim_set_keymap("n", "<leader>n", ":enew<cr>", {noremap=false, silent=true})
-- files
vim.api.nvim_set_keymap("n", "E", "$", {noremap=false})
vim.api.nvim_set_keymap("n", "B", "^", {noremap=false})
vim.api.nvim_set_keymap("n", "TT", ":TransparentToggle<cr>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("n", "st", ":TodoTelescope<cr>", {noremap=true})
vim.api.nvim_set_keymap("n", "<C-c>", ":noh<cr>", {noremap=true, silent=true})
-- splits
vim.api.nvim_set_keymap("n", "<C-W>,", ":vertical resize -10<cr>", {noremap=true})
vim.api.nvim_set_keymap("n", "<C-W>.", ":vertical resize +10<cr>", {noremap=true})
-- vim.keymap.set('n', '<space><space>/', "<cmd>set nohlsearch<CR>")
-- fast movements
vim.api.nvim_set_keymap("n", "J", "5j", {noremap=false})
vim.api.nvim_set_keymap("n", "K", "5k", {noremap=false})
vim.api.nvim_set_keymap("v", "J", "5j", {noremap=false})
vim.api.nvim_set_keymap("v", "K", "5k", {noremap=false})
vim.api.nvim_set_keymap("n", "<leader>w", ":update<cr>", {noremap=false, silent=true})
-- Copilot
vim.g['copilot_no_tab_map'] = true
vim.g['copilot_assume_mapped'] = true
vim.api.nvim_set_keymap('i', '<C-a>', 'copilot#Accept("<CR>")', {expr=true, silent=true})
-- keymap to yank to system's clipboard in normal and visual modes
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', {noremap = true})

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
-- vim.keymap.set({ 'n', 'v' }, '<space>', '<Nop>', {silent=true})

-- Keymaps for Leap
vim.keymap.set('n',        '<leader>f', '<Plug>(leap)')
vim.keymap.set('n',        '<leader>F', '<Plug>(leap-from-window)')
vim.keymap.set({'x', 'o'}, '<leader>f', '<Plug>(leap-forward)')
vim.keymap.set({'x', 'o'}, '<leader>F', '<Plug>(leap-backward)')


-- keymaps for Obsidian
vim.keymap.set('n', '<leader>ot', ':ObsidianToday<CR>', {silent=true})
vim.keymap.set('n', '<leader>oy', ':ObsidianYesterday<CR>', {silent=true})
vim.keymap.set('n', '<leader>om', ':ObsidianTomorrow<CR>', {silent=true})
vim.keymap.set('n', '<leader>od', ':ObsidianDailies<CR>', {silent=true})
vim.keymap.set('n', '<leader>on', ':ObsidianNew<CR>', {silent=true})
vim.keymap.set('n', '<leader>so', ':ObsidianSearch<CR>', {silent=true})
