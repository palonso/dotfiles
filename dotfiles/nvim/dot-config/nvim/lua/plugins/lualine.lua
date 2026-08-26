return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- The trouble breadcrumb in lualine_c only repaints its `%#Group#` spans
      -- onto lualine_c_normal; the separators between segments fall back to
      -- StatusLine. gruvbox sets those to #504945 vs #3c3836, so the gaps show
      -- up as lighter blocks. Align them (tokyonight's happen to match already).
      local function sync_statusline()
        local c = vim.api.nvim_get_hl(0, { name = "lualine_c_normal", link = false })
        local sl = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
        -- The equality check also stops lualine's own rebuild from chasing us.
        if not c.bg or sl.bg == c.bg then
          return
        end
        vim.api.nvim_set_hl(0, "StatusLine", vim.tbl_extend("force", sl, { bg = c.bg }))
      end

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("lualine_statusline_sync", { clear = true }),
        callback = vim.schedule_wrap(sync_statusline),
      })
      vim.schedule(sync_statusline)

      return opts
    end,
  },
}
