function Enable_treesitter_folding()
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    -- Avoid having everything folded by default
    vim.opt.foldenable = false
end

function Toggle_copypaste_mode()
    -- sort of a "ternary" operator in lua
    vim.o.signcolumn = vim.o.signcolumn == "yes" and "no" or "yes"
    vim.o.number = not vim.o.number
end

function Toggle_dark_mode()
    if vim.o.background == "light"
    then
        vim.cmd("colorscheme catppuccin-mocha")
    else
        vim.cmd("colorscheme catppuccin-latte")
    end
end
