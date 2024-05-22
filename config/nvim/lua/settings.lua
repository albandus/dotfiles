-- Reminder: to view current value of a variable, use: "set variable?"

-- Make line numbers default
vim.wo.number = true

-- Ensure mouse mode is disabled
vim.o.mouse = ''

-- case insensitive searching
vim.o.ignorecase = true
-- unless they contain at least one capital letter
vim.o.smartcase = true

-- scrolloff to avoid hitting the bottom of the screen with cursor
vim.o.scrolloff = 8

-- persistent undo
local prefix = vim.fn.expand("~")
vim.o.undodir = prefix .. '/.config/nvim/undo/'
vim.o.undofile = true

-- No wrap by default
vim.o.wrap = false

-- Decrease update time (default to 4000)
vim.o.updatetime = 500

-- Force sign column (avoid diff in display margins with files without git diff)
vim.wo.signcolumn = 'yes'

-- By default textwidth autowrap text in insert mode, changing textwidth allow
-- to format only with gq, or while typing comment (letter c)
-- See :help formatoptions
vim.o.textwidth = 80
vim.o.formatoptions = 'cqjl'

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = { ".local_bashrc" },
    command = "set filetype=bash",
})
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = { ".local_gitconfig", "*/git/config" },
    command = "set filetype=gitconfig",
})
