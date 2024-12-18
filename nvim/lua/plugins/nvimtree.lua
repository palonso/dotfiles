local function on_attach_change(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { 
                desc = "nvim-tree: " .. desc,
                buffer = bufnr,
                noremap = true,
                silent = true,
                nowait = true,
            }
    end

  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', '<Space>tt', api.tree.toggle)
end

return {
    require("nvim-tree").setup({
        on_attach = on_attach_change,
    })
}
