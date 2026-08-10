local function inc_selection()
  local node = vim.treesitter.get_node()
  if not node then return end

  local mode = vim.fn.mode()
  if mode == 'n' then
    vim.cmd('normal! v')
    local sr, sc, er, ec = node:range()
    vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
    vim.cmd('normal! o')
    vim.api.nvim_win_set_cursor(0, { er + 1, ec > 0 and ec - 1 or 0 })
    return
  end

  local parent = node:parent()
  while parent and parent:range() == node:range() do
    parent = parent:parent()
  end
  if not parent then return end
  local sr, sc, er, ec = parent:range()
  vim.cmd('normal! ' .. tostring(sr + 1) .. 'G' .. tostring(sc + 1) .. '|o' .. tostring(er + 1) .. 'G' .. tostring(ec > 0 and ec or 1) .. '|')
end

local function dec_selection()
  local node = vim.treesitter.get_node()
  if not node then return end
  local child = node:child(0)
  if not child then return end
  local sr, sc, er, ec = child:range()
  vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
  vim.cmd('normal! o')
  vim.api.nvim_win_set_cursor(0, { er + 1, ec > 0 and ec - 1 or 0 })
end

return {
  -- https://github.com/nvim-treesitter/nvim-treesitter
  'nvim-treesitter/nvim-treesitter',
  version = false,
  build = ":TSInstall go lua rust bash javascript typescript tsx vim python json toml yaml xml terraform ruby",
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects'
  },
  config = function ()
    -- The main branch does not enable highlighting on its own: start it per
    -- buffer, and only when a parser for that filetype is actually available.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter_highlight', { clear = true }),
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
      end,
    })

    require('nvim-treesitter-textobjects').setup {
      select = {
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v',
          ['@function.outer'] = 'V',
          ['@class.outer'] = '<c-v>',
        },
        include_surrounding_whitespace = true,
      },
    }

    local select_to = require('nvim-treesitter-textobjects.select')
    local keymaps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["ia"] = "@parameter.inner",
      ["aa"] = "@parameter.outer",
      ["ac"] = "@class.outer",
      ["ic"] = "@class.inner",
      ["as"] = "@scope",
    }
    for key, query in pairs(keymaps) do
      vim.keymap.set({ 'x', 'o' }, key, function()
        select_to.select_textobject(query)
      end)
    end

    vim.keymap.set('n', '<a-up>', inc_selection, { desc = 'Init treesitter selection' })
    vim.keymap.set('x', '<a-up>', inc_selection, { desc = 'Expand treesitter selection' })
    vim.keymap.set('x', '<a-down>', dec_selection, { desc = 'Shrink treesitter selection' })
  end
}
