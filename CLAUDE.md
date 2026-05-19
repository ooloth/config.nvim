# Neovim Config — Agent Notes

This is a personal Neovim configuration built on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). It manages plugins, LSP servers, formatters, linters, keymaps, and language-specific tooling through a structured Lua module layout.

## Domain vocabulary

- **Spec file** — a single file in `lua/config/plugins/specs/` that returns one lazy.nvim plugin spec table. Each spec file configures exactly one plugin.
- **Category file** — a file in `lua/config/plugins/` (e.g. `editing.lua`, `lsp.lua`) that sets editor-wide options/keymaps for a theme and returns a table of `require()`d spec files for that category. Category files require manual registration of new specs.
- **Lang file** — a file in `lua/config/plugins/lang/` (e.g. `python.lua`, `go.lua`) that returns a table of plugin specs for a specific language. Lang files are auto-loaded by `util.require_all_files_in_config_directory` — no manual registration needed.
- **`opts` vs `config`** — prefer `opts = { ... }` over `config = function() ... end` when the plugin supports it. `opts` is simpler and composable. Use `config` only when you need side effects beyond passing options (e.g. setting up autocommands, calling `vim.diagnostic.config`, etc.).
- **Lazy-loading events** — `VeryLazy` defers a plugin until after the UI is ready. `BufNewFile`/`BufRead`/`BufWritePre` load on buffer activity. `keys`, `cmd`, and `ft` load on first use of a keymap, command, or filetype. Prefer the most specific trigger to keep startup fast.
- **Two-tier registration** — general plugins go in a spec file + a category file (`require()` added manually). Language-specific plugins go only in a lang file and are picked up automatically.

## Check commands

```bash
# Format check (Lua files only)
stylua --check .
```

StyLua is the only formatter. Its settings are in `.stylua.toml` (130-column width, 2-space indent, single quotes, always-parenthesise calls, sort requires).

## Exercising real code paths

Full Neovim execution requires a running display and is not possible in a headless CI environment. The closest you can get is:

```bash
# Start Neovim in headless mode to check for startup errors (exits immediately)
nvim --headless -c "qall"

# Run the built-in health checks for a specific module
nvim --headless -c "checkhealth config.util" -c "qall"
```

These will surface missing dependencies and Lua errors on startup but won't exercise plugin behaviour. Manual verification requires opening Neovim interactively.

## Non-obvious constraints

- **Do not register lang files manually.** `languages.lua` calls `util.require_all_files_in_config_directory('plugins/lang')` — adding a `require()` for a lang file in a category file will double-load it.
- **Do not alter the `require_all_files_in_config_directory` utility.** It relies on a hardcoded absolute path (`~/Repos/ooloth/config.nvim/lua/config/`). Changing the path or the loading mechanism will silently break all lang files.
- **Prefer `opts` for new specs.** Use `config` only when `opts` genuinely cannot express what's needed. Adding a `config` function where `opts` would suffice makes the spec harder to extend via lazy.nvim's spec merging.
- **`ftplugin/` files are filetype-scoped.** Files in `ftplugin/` run automatically when a matching filetype is opened. Do not put global config there.

## Docs

| Playbook | Description |
| -------- | ----------- |
| [Add a new plugin](docs/playbooks/add-new-plugin.md) | Create a spec file and register it in the right category |
