# Contributing

## Check a change

```sh
stylua --check .                                    # formatting; settings are in .stylua.toml
nvim --clean --headless -l tests/navigation_test.lua  # tests
```

## Tests

Each file in `tests/` is a Lua script that Neovim runs headless with `-l`. It prints `ok` or `FAIL`
for each test and exits 1 if any failed. `--clean` keeps your own config and plugins out of the
run, so a test loads only what it requires itself.

`tests/navigation_test.lua` covers the `<c-h>`/`<c-l>` mappings in
`lua/config/plugins/specs/vim-tmux-navigator.lua`: tmux, Neovim splits, and the handoff to Rex panes
at the edge. One test sources the installed plugin from `~/.local/share/nvim-ide/lazy/`, so open
Neovim with `NVIM_APPNAME=nvim-ide` once before running it on a new machine.

There is no CI. Run both commands before committing.
