-- Initialize a global variable to track Leap status
_G.leap_active = false

-- Autocommand to track LeapEnter
vim.api.nvim_create_autocmd('User', {
  pattern = 'LeapEnter',
  callback = function ()
    _G.leap_active = true  -- Set the global variable when Leap is active
    require('lualine').refresh({ place = { 'statusline' } })
  end,
})

-- Autocommand to track LeapLeave
vim.api.nvim_create_autocmd('User', {
  pattern = 'LeapLeave',
  callback = function ()
    _G.leap_active = false  -- Set the global variable when Leap is inactive
    require('lualine').refresh({ place = { 'statusline' } })
  end,
})

-- Leap Status for Lualine
local leap_status = function()
  if _G.leap_active then
    return 'Leap'  -- Display when Leap is active
  else
    return ''  -- Empty string when Leap is inactive
  end
end

-- Color definitions for lualine
local colors = {
  active = { fg = '#24273a', bg = '#ed8796' },  -- When leap is active (white text, pink background)luali
  inactive = { fg = '#24273a', bg = '#ed8796' }, -- When leap is inactive (white text, blue background)
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    component_separators = '',
    section_separators = '',
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_x = {
      {
        require("noice").api.statusline.mode.get,
        cond = require("noice").api.statusline.mode.has,
      }
    },
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'buffers',
        symbols = {
          alternate_file = '',
        },
      },
    },
    lualine_x = {'diff', 'branch'},
    lualine_y = {
      {
        leap_status,  -- Add the leap status function here
        color = function()
          -- Change color for the leap status text
          if _G.leap_active then
            return colors.active  -- Pink when leap is active
          else
            return colors.inactive  -- Blue when leap is inactive
          end
        end
      },
      {
        'macro',
        fmt = function()
          local reg = vim.fn.reg_recording()
          if reg ~= '' then
            return 'Recording @' .. reg
          end
          return nil
        end,
        color = { fg = '#24273a', bg = '#ed8796' },
        draw_empty = false,
      },
    },
    lualine_z = {'progress', 'location'},
  },
}

-- vim: ts=2 sts=2 sw=2 et
