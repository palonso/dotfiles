return {
  "folke/tokyonight.nvim",
  opts = {
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
    },
    on_highlights = function(hl, c)
      -- Region past 'textwidth' (see lua/config/autocmds.lua). Default is
      -- c.black (#1b1d2b); use the statusline background instead so it reads
      -- as a slightly lighter shade matching the bar at the bottom.
      hl.ColorColumn = { bg = c.bg_statusline }
    end,
  },
}
