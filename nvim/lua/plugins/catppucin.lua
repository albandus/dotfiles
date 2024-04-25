return {
  -- Pastel theme, middle ground between low and high contrast
  -- https://github.com/catppuccin/nvim
  {
    'catppuccin/nvim',
    lazy = false,
    config = function ()
      require("catppuccin").setup({
        -- Lots of integration enabled by default, for more details see:
        -- https://github.com/catppuccin/nvim?tab=readme-ov-file#integrations
        integrations = {
          barbar = true,
        },
      })
      vim.cmd("colorscheme catppuccin")
    end
  },
}
