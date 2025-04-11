-- https://github.com/echasnovski/mini.nvim
return {
  {
    'echasnovski/mini.nvim',
    -- to get main branch, latest version as suggested in readme
    version = false,
    config = function()
      -- move selection around (Default keys: alt+hjkl)
      require("mini.move").setup()

      -- show buffer tabs
      require("mini.tabline").setup({
        show_icons = false
      })
      -- -- improved statusline
      -- require("mini.statusline").setup({
      --   use_icons = false
      -- })
      -- comment code helper
      require("mini.comment").setup({
        mappings = {
          -- Toggle comment for both
          -- Normal and Visual modes
          comment = '<c-c>',

          -- Toggle comment on current line
          comment_line = '<c-c>',

          -- Toggle comment on visual selection
          comment_visual = '<c-c>',

          -- Define 'comment' textobject (like `dgc` - delete whole comment block)
          -- Works also in Visual mode if mapping differs from `comment_visual`
          textobject = 'gc',
        },
      })
      -- help panel, copy / paste from mini.clue doc
      -- https://github.com/echasnovski/mini.clue?tab=readme-ov-file#default-config
      local miniclue = require('mini.clue')
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        window = {
          delay = 500,
          config = {
            width = "auto"
          }
        }
      })

      -- auto-completion
      -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-completion.md
      require("mini.completion").setup()
      -- Use `<Tab>` and `<S-Tab>` for navigation through completion list (source: :help mini.completion)
      vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
      vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

    end
  }
}
