# termex.vim

Extra terminal functionalities for Vim.

This is a simple plugin including the following features.

- Re-use existing terminals automatically
- Open terminals in floating windows
    - disabled by default, but you can enable it by `let g:termex_use_floatwin = v:true`

## Usage

Just run `:Terminal` command to open terminal window (same as built-in `terminal` command).
After closing it, you can re-open that terminal window by just running `:Terminal` command again.

You can open terminal in neovim floatwin by the following setting.

```vim
let g:termex_use_floatwin = v:true
```
