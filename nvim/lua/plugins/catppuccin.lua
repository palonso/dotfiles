return {
  -- Configure LazyVim to load gruvbox
  {
    "catppuccin",
    opts = {
      transparent_background = true,
      float = {
        transparent = true,
        solid = false,
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
