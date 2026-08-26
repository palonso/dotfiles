return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        -- Do not show diagnostics in the bufferline
        diagnostics = "",
      },
      highlights = {
        -- gruvbox ships no BufferLine groups, so bufferline derives the active
        -- indicator from TabLineSel.bg and it lands on the tab background.
        indicator_selected = { fg = "#fe8019" },
      },
    },
  },
}
