# termex.vim

Extra terminal functionalities for Vim.

This is a simple plugin including the following features.

- Re-use existing terminals automatically
- Open terminals with `split`, `vsplit` and floating window
- Support terminal UI tools such as [lazygit](https://github.com/jesseduffield/lazygit) without keybinding annoyance.

## Usage

This is one of the simplest use cases of this plugin.

1. Just run `:Term` command to open terminal with your interactive shell
1. After closing it, you can re-open that terminal by just running `:Term` again
1. You can `:STerm`/`:VTerm`/`:FTerm` instead of `:Term`

`:Term` (and other commands) can take any shell commands as arguments.

For terminal UI tools such as [lazygit](https://github.com/jesseduffield/lazygit), use `:Tui` instead of `:Term`.
This command do the following additional things compared with `:Term`.

- Automatically enter into insert mode
- All terminal-mode mappings are cleared
    - e.g. to prevent <esc> from returning to normal mode

For more details, please check `:h termex`.
