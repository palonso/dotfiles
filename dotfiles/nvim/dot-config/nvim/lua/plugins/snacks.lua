return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      ignored = true, -- global default: show gitignored
      sources = {
        files = { ignored = false },
        explorer = { ignored = true }, -- the file browser
      },
    },
  },
}
