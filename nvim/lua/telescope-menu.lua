-- Define custom telescope menu
-- Variable used in telescope config, must exists before lazy calls
-- "telescope.lua". Define separately as it depends on other extensions.
-- See https://github.com/octarect/telescope-menu.nvim
Telescope_custom_menu = {
    { "Enable folding (with Treesitter)", function () Enable_treesitter_folding() end },
    { "Toggle copy/paste mode", function() Toggle_copypaste_mode() end },
    { "Toggle dark/light theme", function() Toggle_dark_mode() end },
    { "", "" },
    { "Telescope: help tags", "Telescope help_tags" },
    { "Telescope: keymaps", "Telescope keymaps" },
}
