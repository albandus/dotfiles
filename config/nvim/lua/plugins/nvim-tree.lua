-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, desc = "NvimTree: toggle" })
vim.keymap.set("n", "<leader>o", ":NvimTreeFindFile<CR>", { silent = true, desc = "NvimTree: find in tree" })

-- https://github.com/nvim-tree/nvim-tree.lua
return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
  config = function()
    local function my_on_attach(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
      vim.keymap.set('n', 'h', api.node.open.horizontal, opts('Open: Horizontal Split'))
      vim.keymap.set('n', 't', api.node.open.tab, opts('Open: New Tab'))
      vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
    end
    require("nvim-tree").setup({
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      },
      filters = {
        dotfiles = true,
      },
      on_attach = my_on_attach,
    })
  end
}
