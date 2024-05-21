-- space does not anything in normal mode (without this, moves the cursor)
vim.api.nvim_set_keymap('n', '<Space>', '<Nop>', { noremap = true, silent = true })

-- backspace delete char before cursor in normal mode
vim.api.nvim_set_keymap('n', '<bs>', 'X', { noremap = true, silent = true })

-- center searches on screen
vim.api.nvim_set_keymap('n', 'n', 'nzz', { silent = true })
vim.api.nvim_set_keymap('n', 'N', 'Nzz', { silent = true })

-- easy access to system clipboard
vim.api.nvim_set_keymap("n", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
vim.api.nvim_set_keymap("v", "<leader>y", '"+y', { noremap = true, silent = true, desc = "Copy to system clipboard" })
vim.api.nvim_set_keymap("n", "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste from system clipboard" })

-- clear search highlights on esc
vim.api.nvim_set_keymap("n", '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true, desc = "Clear search highlights" })

-- resize vertical split
vim.api.nvim_set_keymap("n", "<leader>.", ':vertical resize +15<CR>', { noremap = true, silent = true, desc = "Vertical resize: +15" })
vim.api.nvim_set_keymap("n", "<leader>,", ':vertical resize -15<CR>', { noremap = true, silent = true, desc = "Vertical resize: -15" })

-- LSP next/prev diagnostic: form some reason does not work if set in "lsp.lua" with other keybindings
vim.keymap.set("n", "<leader>]", vim.diagnostic.goto_next, {desc = "Goto next diagnostic"})
vim.keymap.set("n", "<leader>[", vim.diagnostic.goto_prev, {desc = "Goto previous diagnostic"})

-- delete current buffer (and remove it from buffer list)
vim.api.nvim_set_keymap("n", '<C-q>', ':bd<CR>', { noremap = true, silent = true, desc = "Barbar: Close current buffer" })
