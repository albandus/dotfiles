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
    -- local theme = vim.fn.system('tmux show-environment THEME')
    -- if theme == "dark"
    -- then
    --     vim.cmd("colorscheme catppuccin-latte")
    --     -- vim.fn.system('nuit')
    -- else
    --     vim.cmd("colorscheme catppuccin-mocha")
    --     -- vim.fn.system('jour')
    -- end
    if vim.o.background == "light"
    then
        vim.cmd("colorscheme catppuccin-mocha")
        os.execute("tmux set-environment THEME 'dark'")
        os.execute("tmux source-file ~/.config/tmux/tmux_dark.conf")
    else
        vim.cmd("colorscheme catppuccin-latte")
        os.execute("tmux set-environment THEME 'light'")
        os.execute("tmux source-file ~/.config/tmux/tmux_light.conf")
    end
end
