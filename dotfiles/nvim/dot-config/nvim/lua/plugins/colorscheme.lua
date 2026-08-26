return {
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      -- Let Ghostty's background-opacity show through. Clears the background
      -- on Normal/NormalFloat/SignColumn/WinSeparator but not StatusLine.
      transparent_mode = true,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
