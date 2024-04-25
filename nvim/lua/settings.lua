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
vim.o.undodir = prefix .. '/.nvim_undo/'
vim.o.undofile = true

-- No wrap by default
vim.o.wrap = false

-- Decrease update time (default to 4000)
vim.o.updatetime = 500

-- Force sign column (avoid diff in display margins with files without git diff)
vim.wo.signcolumn = 'yes'

vim.o.textwidth=80

-- From old vim config
-- Highlight whitespace chars. Provide function :StripWhitespace
-- Plug 'https://github.com/ntpeters/vim-better-whitespace'
--
--Custom names to force "bash" syntax detection
--if exists("*SetFileTypeSH")
--  " Custom syntax file associations
--  au BufNewFile,BufRead .bashrc*,bashrc,bash_*,.bash_*, call SetFileTypeSH("bash")
--endif
