return {
  {
    "catppuccin",
    -- NOTE: This is a temporary fix until lazyvim colorescheme updates get() -> get_*()
    commit = "9a9a875",
    opts = {
      integrations = {
        -- NOTE: This is not working for new and I couldn't find the reason so far
        blink_cmp = {
          enabled = true,
          style = "bordered",
        },
      },
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
