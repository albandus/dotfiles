dotfiles
========

- Install script valid only for Linux, very basic, could be done manually,
  mostly written as a reminder. For mac, MUST be done manually adapting command
  as needed.
- Alacritty / Tmux: mac version done by copying linux version and adapting some
  values. No tries to make it dynamic / auto. On mac after new install, check
  alacritty file if any font issue.

## Nvim

To get syntax highlighting install system package `tree-sitter-cli`.
Then from nvim, run:
```
:TSInstall bash go lua rust javascript typescript tsx vim python json toml yaml xml
```

Other useful commands:
- List installed languages support: `:checkhealth nvim-treesitter`
- Update `:TSUpdate`

