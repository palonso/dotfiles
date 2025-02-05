local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
-- Fixes Notify opacity issues
vim.o.termguicolors = true

require('lazy').setup({

  -- mini.nvim suite
  {
    'echasnovski/mini.nvim', version = false,
  },

  -- Fancier statusline
  {'nvim-lualine/lualine.nvim'},

  -- notifications
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        -- add any options here
        routes = {
          {
            filter = {
              event = 'msg_show',
              any = {
                { find = '%d+L, %d+B' },
                { find = '; after #%d+' },
                { find = '; before #%d+' },
                { find = '%d fewer lines' },
                { find = '%d more lines' },
              },
            },
            opts = {skip=true},
          }
        },
      })
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify"
    }
  },

  -- LSP Diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require('tiny-inline-diagnostic').setup()
    end
  },

  -- colors
  {
    "catppuccin/nvim", as = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
        integrations = {
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = true,
        },
      })
      vim.cmd.colorscheme "catppuccin"
    end
  },

  -- git stuff
  'tpope/vim-fugitive',
  'lewis6991/gitsigns.nvim',
  'ThePrimeagen/git-worktree.nvim',

  -- LSP Configuration & Plugins
  { 
   'neovim/nvim-lspconfig',
   dependencies = {
     -- Automatically install LSPs to stdpath for neovim
     'williamboman/mason.nvim',
     'williamboman/mason-lspconfig.nvim',
     -- Useful status updates for LSP
     -- 'j-hui/idget.nvim',
   }
  },

  -- Formatting
  'lukas-reineke/lsp-format.nvim',
  
  -- Comments
  'tpope/vim-commentary',

  -- Navigation
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  'nvim-telescope/telescope-symbols.nvim',

  {
   "nvim-tree/nvim-tree.lua",
   version = "*",
   lazy = false,
   requires = {
     "nvim-tree/nvim-web-devicons",
   },
   config = function()
     require("nvim-tree").setup {}
   end,
   keys = {
     {
       '<Space>tt',
       function()
         require("nvim-tree.api").tree.open({ find_file = true })
       end,
       desc = 'Find file in Tree'
     },
   },
  },

  -- Copilot
  {
   'github/copilot.vim',
  },

  -- Support for Latex
  -- {
  --   "lervag/vimtex",
  --   lazy = false,     -- we don't want to lazy load VimTeX
  --   init = function()
  --     vim.g.vimtex_view_method = 'skim'
  --   end
  -- },

  -- Autocompletion support
  {
   "hrsh7th/nvim-cmp",
   dependencies = {
     "hrsh7th/cmp-nvim-lsp",
     "hrsh7th/cmp-buffer",
     "hrsh7th/cmp-path",
     "hrsh7th/cmp-cmdline",
     "L3MON4D3/LuaSnip",
     -- "micangl/cmp-vimtex",
   },
  },

  {
   "lukas-reineke/indent-blankline.nvim",
     dependencies = { "nvim-lua/plenary.nvim" },
   config = function()
     require("ibl").setup()
   end,
  },

  -- 2-char search
  {
   "ggandor/leap.nvim",
   lazy = false,
  },

  -- Substitute command
  {
    "gbprod/substitute.nvim",
    config = function() 
      require("substitute").setup()
    end,
  },

  -- Markdown rendering
  {
   'MeanderingProgrammer/render-markdown.nvim',
   dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
   config = function()
     require('render-markdown').setup({
       heading = {
         backgrounds = {},
         sign = false,
       },
     })
   end
  },

  -- Obsidian support
  {
    "epwalsh/obsidian.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = false,
    ft = "markdown",
    opts = {
      workspaces = {
        {
          name = "Notes",
          path = "~/syncthing/notes/Notes/",
        },
      },
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "daily_notes",
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = "%B %-d, %Y",
        -- Optional, default tags to add to each new daily note created.
        default_tags = { "daily-notes" },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil
      },
        -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },
    },
  },

  -- Better syntax highlighting
  {
   "nvim-treesitter/nvim-treesitter",
   config = function()
     require'nvim-treesitter.configs'.setup({
       -- A list of parser names, or "all" (the listed parsers MUST always be installed)
       ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "python" , "bash"},

       -- Install parsers synchronously (only applied to `ensure_installed`)
       sync_install = false,

       -- Automatically install missing parsers when entering buffer
       -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
       auto_install = true,

       -- List of parsers to ignore installing (or "all")
       ignore_install = { "javascript" },

       ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
       -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

       highlight = {
         enable = true,

         -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
         -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
         -- the name of the parser)
         -- list of language that will be disabled
         disable = { "c", "rust" },
         -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
         disable = function(lang, buf)
             local max_filesize = 100 * 1024 -- 100 KB
             local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
             if ok and stats and stats.size > max_filesize then
                 return true
             end
         end,

         -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
         -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
         -- Using this option may slow down your editor, and you may see some duplicate highlights.
         -- Instead of true it can also be a list of languages
         additional_vim_regex_highlighting = false,
       },
     })
   end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
})


-- vim: ts=2 sts=2 sw=2 et

      --provider = "ollama",
      --vendors = {
      --  ---@type AvanteProvider
      --  ollama = {
      --    api_key_name = "",
      --    ask = "",
      --    endpoint = "http://127.0.0.1:11434/api",
      --    model = "llama3.2",
      --    -- model = "phi4",
      --    -- model = "qwen2.5-coder:14b",
      --    -- model = "llama3.1:latest",
      --    -- model = "deepseek-r1:8b",
      --    parse_curl_args = function(opts, code_opts)
      --      return {
      --        url = opts.endpoint .. "/chat",
      --        headers = {
      --          ["Accept"] = "application/json",
      --          ["Content-Type"] = "application/json",
      --        },
      --        body = {
      --          model = opts.model,
      --          options = {
      --            num_ctx = 131072,
      --          },
      --          messages = require("avante.providers").copilot.parse_messages(code_opts), -- you can make your own message, but this is very advanced
      --          stream = true,
      --        },
      --      }
      --    end,
      --    parse_stream_data = function(data, handler_opts)
      --      -- Parse the JSON data
      --      local json_data = vim.fn.json_decode(data)
      --      -- Check for stream completion marker first
      --      if json_data and json_data.done then
      --        handler_opts.on_complete(nil)  -- Properly terminate the stream
      --        return
      --      end
      --      -- Process normal message content
      --      if json_data and json_data.message and json_data.message.content then
      --        -- Extract the content from the message
      --        local content = json_data.message.content
      --        -- Call the handler with the content
      --        handler_opts.on_chunk(content)
      --      end
      --    end,
      --  },
      --},
