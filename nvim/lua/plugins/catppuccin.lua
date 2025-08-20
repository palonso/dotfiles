return {
  {
    "catppuccin",
    -- NOTE: This is a temporary fix until lazyvim colorescheme updates get() -> get_*()
    commit = "9a9a875",
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
