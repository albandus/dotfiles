-- https://github.com/nvim-lualine/lualine.nvim
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup({
      theme = "catppuccin",
      sections = {
        lualine_a = {
          {
            'mode',
            fmt = function(str) return str:sub(1,1) end,
          },
        },
        lualine_c = {
          {
            'filename',
            path = 1,
          },
        },
      },
    })
  end
}
