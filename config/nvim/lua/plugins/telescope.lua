return {
  -- Fuzzy Finder Algorithm which dependencies local dependencies to be built. Only load if `make` is available
  -- https://github.com/nvim-telescope/telescope.nvim
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable 'make' == 1 },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
      'octarect/telescope-menu.nvim',
    },
    config = function()
      local lga_actions = require("telescope-live-grep-args.actions")
      require("telescope").setup({
        extensions = {
          live_grep_args = {
            auto_quoting = true,
            mappings = {
              i = {
                ["<C-k>"] = lga_actions.quote_prompt(),
                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " -t " }),
              },
            },
          },
          menu = {
            default = {
              items = Telescope_custom_menu,
            },
          },
        },
      })
      require("telescope").load_extension("live_grep_args")
      require("telescope").load_extension("menu")
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')

      vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = 'Telescope: existing buffers' })
      vim.keymap.set('n', '<leader>f', require('telescope.builtin').find_files, { desc = 'Telescope: file picker' })
      vim.keymap.set('n', '<leader>/', require('telescope').extensions.live_grep_args.live_grep_args, { desc = 'Telescope: live grep' })
      vim.keymap.set('n', '<leader>m', require('telescope.builtin').resume, { desc = 'Telescope: resume' })
      vim.keymap.set('n', '<leader>\'', require('telescope.builtin').registers, { desc = 'Telescope: registers' })
      vim.keymap.set('n', '<F8>', ":lua require('telescope').extensions.menu.menu({})<CR>", { desc =  'Telescope: menu' })

      vim.keymap.set('n', '<leader>s', require('telescope.builtin').lsp_document_symbols, { desc =  'Telescope: symbols picker' })
      vim.keymap.set('n', '<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc =  'Telescope: workspace symbols picker' })
      vim.keymap.set('n', '<leader>j', require('telescope.builtin').jumplist, { desc = 'Telescope: jumplist' })
      vim.keymap.set('n', '<leader>d', require("telescope.builtin").diagnostics, { desc =  'Telescope: diagnostics picker' })
    end
  },
}
