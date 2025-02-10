local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Ollama API Documentation https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion
local role_map = {
	user = "user",
	assistant = "assistant",
	system = "system",
	tool = "tool",
}

---@param opts AvantePromptOptions
local parse_messages = function(self, opts)
	local messages = {}
	local has_images = opts.image_paths and #opts.image_paths > 0
	-- Ensure opts.messages is always a table
	local msg_list = opts.messages or {}
	-- Convert Avante messages to Ollama format
	for _, msg in ipairs(msg_list) do
		local role = role_map[msg.role] or "assistant"
		local content = msg.content or "" -- Default content to empty string
		-- Handle multimodal content if images are present
		-- *Experimental* not tested
		if has_images and role == "user" then
			local message_content = {
				role = role,
				content = content,
				images = {},
			}
			for _, image_path in ipairs(opts.image_paths) do
				local base64_content = vim.fn.system(string.format("base64 -w 0 %s", image_path)):gsub("\n", "")
				table.insert(message_content.images, "data:image/png;base64," .. base64_content)
			end
			table.insert(messages, message_content)
		else
			table.insert(messages, {
				role = role,
				content = content,
			})
		end
	end
	return messages
end

local function parse_curl_args(self, code_opts)
	-- Create the messages array starting with the system message
	local messages = {
		{ role = "system", content = code_opts.system_prompt },
	}
	-- Extend messages with the parsed conversation messages
	vim.list_extend(messages, self:parse_messages(code_opts))
	-- Construct options separately for clarity
	local options = {
		num_ctx = (self.options and self.options.num_ctx) or 8192,
		temperature = code_opts.temperature or (self.options and self.options.temperature) or 0,
	}
	-- Check if tools table is empty
	local tools = (code_opts.tools and next(code_opts.tools)) and code_opts.tools or nil
	-- Return the final request table
	return {
		url = self.endpoint .. "/api/chat",
		headers = {
			Accept = "application/json",
			["Content-Type"] = "application/json",
		},
		body = {
			model = self.model,
			messages = messages,
			options = options,
			-- tools = tools, -- Optional tool support
			stream = true, -- Keep streaming enabled
		},
	}
end

local function parse_stream_data(data, handler_opts)
	local json_data = vim.fn.json_decode(data)
	if json_data then
		if json_data.done then
			handler_opts.on_stop({ reason = json_data.done_reason or "stop" })
			return
		end
		if json_data.message then
			local content = json_data.message.content
			if content and content ~= "" then
				handler_opts.on_chunk(content)
			end
		end
		-- Handle tool calls if present
		if json_data.tool_calls then
			for _, tool in ipairs(json_data.tool_calls) do
				handler_opts.on_tool(tool)
			end
		end
	end
end

---@type AvanteProvider
local ollama = {
	api_key_name = "",
	-- endpoint = "http://127.0.0.1:11434",
  endpoint = "http://localhost:11434",
  model = "deepseek-r1:14b",
  -- model = "qwen2.5-coder:14b",
  -- model = "llama3.1:latest",
	parse_messages = parse_messages,
	parse_curl_args = parse_curl_args,
	parse_stream_data = parse_stream_data,
}

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
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          gitsigns = true,
          leap = true,
          mason = true,
          noice = true,
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
    -- Add telescope and treessiter
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope.nvim" },
    version = "*",  -- recommended, use latest release instead of latest commit
    lazy = false,
    enabled = function() return vim.fn.getenv("OBSIDIAN_WORKSPACE_PATH") ~= vim.NIL end,
    ft = "markdown",
    opts = {
      ui = { 
        enable = false,
        -- Replace the defaults by just the TODO and DONE checkboxes.
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" }
        },
      },  -- Use markdown-render instead.
      workspaces = {
        {
          name = "Notes",
          path = vim.fn.getenv("OBSIDIAN_WORKSPACE_PATH"),
        },
      },
      -- Optional, if you keep notes in a specific subdirectory of your vault.
      notes_subdir = "0_inbox",
      new_notes_location = "notes_subdir",
      -- Daily notes configuration.
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
      -- provider = "copilot",
      -- auto_suggestions_provider = "copilot",
      auto_suggestions_provider = "ollama",
      debug = true,
      provider = "ollama",
      vendors = {
        ---@type AvanteProvider
        ollama = ollama,
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
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
