return {
  -- https://github.com/romgrk/barbar.nvim
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  init = function() vim.g.barbar_auto_setup = false end,
  version = '^1.7.0', -- optional: only update when a new 1.x version is released
  config = function()
    require('barbar').setup({
      animation = false,
      clickable = false,
      icons = {
        -- remove 'x' button
        button='',
        -- remainging in icons: copy/paste from doc in readme
        gitsigns = {
          added = {enabled = true, icon = '+'},
          changed = {enabled = true, icon = '~'},
          deleted = {enabled = true, icon = '-'},
        },
      },
      semantic_letters = false,
    })

    -- close current buffer (and remove it from buffer list)
    vim.api.nvim_set_keymap("n", '<C-q>', ':BufferClose<CR>', { noremap = true, silent = true, desc = "Barbar: Close current buffer" })
    -- go to next and previous buffers
    vim.api.nvim_set_keymap('n', 'gn', ':BufferNext<CR>', { noremap = true, silent = true, desc = "Barbar: Go to next buffer" })
    vim.api.nvim_set_keymap('n', 'gp', ':BufferPrevious<CR>', { noremap = true, silent = true, desc = "Barbar: Go to previous buffer" })
    -- pick buffer
    vim.api.nvim_set_keymap('n', '<leader>g', ':BufferPick<CR>', { noremap = true, silent = true, desc = "Barbar: pick buffer" })
  end
}
