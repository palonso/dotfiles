return {
  {
    "catppuccin",
    opts = {
      transparent_background = true,
      float = {
        transparent = true,
        solid = false,
      },
      -- NOTE: According to Catppuccin docs, BlinkCmp integration is available.
      -- However, it doesn't seem to work as expected.
      -- Doing a manual override below instead for now.
      --
      -- integrations = {
      --   blink_cmp = {
      --     style = "bordered",
      --   },
      -- },

      custom_highlights = function(colors)
        return {
          -- force BlinkCmpMenu (linked to Pmenu) to be transparent
          Pmenu = { bg = "NONE", fg = colors.text },
          PmenuSel = { bg = colors.surface0, fg = colors.text },
          PmenuSbar = { bg = colors.mantle },
          PmenuThumb = { bg = colors.overlay0 },
          PmenuBorder = { fg = colors.overlay0 },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
