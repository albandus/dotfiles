return {
  "christoomey/vim-tmux-navigator",
  -- lazy load on command:
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  -- lazy load on key mapping:
  keys = {
    { "<c-Left>", "<cmd>TmuxNavigateLeft<cr>" },
    { "<c-Down>", "<cmd>TmuxNavigateDown<cr>" },
    { "<c-Up>", "<cmd>TmuxNavigateUp<cr>" },
    { "<c-Right>", "<cmd>TmuxNavigateRight<cr>" },
    { "<c-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
  },
}
