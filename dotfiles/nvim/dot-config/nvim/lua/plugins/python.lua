-- Python toolchain: black + isort + flake8 (instead of LazyVim's default ruff).
-- All three auto-discover the project's config files:
--   pyproject.toml  -> [tool.black] / [tool.isort]
--   .flake8         -> [flake8]
--   pyrightconfig.json -> pyright (picked up automatically by the LSP)

-- Find the nearest config file walking up from `path`.
---@param names string[]
---@param path? string
local function find_upward(names, path)
  return vim.fs.find(names, {
    path = path or vim.api.nvim_buf_get_name(0),
    upward = true,
    type = "file",
  })[1]
end

local FLAKE8_CONFIGS = { ".flake8", "setup.cfg", "tox.ini" }

return {
  -- 1. Drop the ruff language server: this project lints with flake8.
  --    (pyright stays and reads pyrightconfig.json on its own.)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = { enabled = false },
        ruff_lsp = { enabled = false },
      },
    },
  },

  -- 2. Format with isort then black. conform's builtin recipes already set
  --    cwd = nearest dir containing pyproject.toml, so line-length 90 /
  --    profile=black / lines_after_imports=2 are honoured with zero args.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
      },
    },
  },

  -- 3. Lint with flake8. nvim-lint runs linters from Neovim's cwd, so pass the
  --    config explicitly to stay correct regardless of :cd.
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "flake8" },
      },
      linters = {
        flake8 = {
          -- Only run when the project actually ships a flake8 config.
          condition = function(ctx)
            return find_upward(FLAKE8_CONFIGS, ctx.filename) ~= nil
          end,
          prepend_args = {
            "--config",
            function()
              return find_upward(FLAKE8_CONFIGS)
            end,
          },
        },
      },
    },
  },

  -- 4. Make sure the tools exist.
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "black", "isort", "flake8" } },
  },
}
