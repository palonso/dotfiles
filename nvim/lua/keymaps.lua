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


-- keymap to yank to system's clipboard in normal and visual modes
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', {noremap=true})
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', {noremap = true})

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
-- vim.keymap.set({ 'n', 'v' }, '<space>', '<Nop>', {silent=true})

-- Keymaps for plugins

-- Copilot
vim.g['copilot_no_tab_map'] = true
vim.g['copilot_assume_mapped'] = true
vim.api.nvim_set_keymap('i', '<C-a>', 'copilot#Accept("<CR>")', {expr=true, silent=true})

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

-- keymaps for substitute
vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })
-- keymaps for substitute over a range
vim.keymap.set("n", "<space>r", require('substitute.range').operator, { noremap = true })
vim.keymap.set("x", "<space>r", require('substitute.range').visual, { noremap = true })
vim.keymap.set("n", "<space>rr", require('substitute.range').word, { noremap = true })

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sS', require('telescope.builtin').git_status, { desc = '' })
vim.keymap.set("n", "<leader>sr", "<CMD>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", silent)
vim.keymap.set("n", "<leader>sR", "<CMD>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", silent)
vim.keymap.set("n", "<leader>sn", "<CMD>lua require('telescope').extensions.notify.notify()<CR>", silent)

-- Function to search on the dotfiles directory defined by the environment variable DOTFILES_PATH
vim.keymap.set("n", "<leader>s.", function()
  local cwd = vim.env.DOTFILES_PATH
  if not cwd or cwd == "" then
    vim.api.nvim_err_writeln("Environment variable 'DOTFILES_PATH' is not set or is empty")
    return
  end
  require("telescope.builtin").find_files({ cwd = cwd })
end, { silent = true })

-- vim.keymap.set("n", "<Leader>sb", ":Telescope git_branches <CR>", silent)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

