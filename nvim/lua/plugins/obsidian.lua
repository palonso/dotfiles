return {
  "epwalsh/obsidian.nvim",
  -- Add telescope and treessiter
  dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope.nvim" },
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = false,
  enabled = function()
    return vim.fn.getenv("OBSIDIAN_WORKSPACE_PATH") ~= vim.NIL
  end,
  ft = "markdown",
  opts = {
    ui = {
      enable = false,
      -- Replace the defaults by just the TODO and DONE checkboxes.
      checkboxes = {
        [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        ["x"] = { char = "", hl_group = "ObsidianDone" },
      },
    }, -- Use markdown-render instead.
    workspaces = {
      {
        name = "Notes",
        path = vim.fn.getenv("OBSIDIAN_WORKSPACE_PATH"),
      },
    },
    -- Optional, if you keep notes in a specific subdirectory of your vault.
    notes_subdir = "0_inbox",
    new_notes_location = "notes_subdir",
    -- Daily notes configuration.
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = "daily_notes",
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = "%B %-d, %Y",
      -- Optional, default tags to add to each new daily note created.
      default_tags = { "daily-notes" },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
    },
    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },
  },
}
