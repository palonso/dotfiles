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
      template = "daily.md",
    },

    -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    -- Optional, for templates (see below).
    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- Open the URL in the default web browser.
      vim.fn.jobstart({ "open", url }) -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
      -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      -- vim.ui.open(url) -- need Neovim 0.10.0+
    end,
  },
}
