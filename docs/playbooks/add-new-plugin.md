# Add a New Plugin

## General plugins

### 1. Create a spec file

Create `lua/config/plugins/specs/<plugin-name>.lua`:

```lua
---@module '<plugin-name>'

-- One-line description of what this plugin does

-- DOCS: https://github.com/<author>/<plugin-name>

return {
  '<author>/<plugin-name>',
  event = 'VeryLazy', -- or keys = {...}, cmd = {...}, ft = {...}
  opts = {
    -- plugin config
  },
}
```

### 2. Register the spec in a category file

Add a `require` line to the return table of the appropriate category file in `lua/config/plugins/`:

| Category file    | Purpose                                     |
| ---------------- | ------------------------------------------- |
| `debugging.lua`  | DAP adapters and UI                         |
| `editing.lua`    | Text manipulation, completion, pairs        |
| `git.lua`        | Git integration                             |
| `intelligence.lua` | AI, formatting, linting, diagnostics      |
| `lsp.lua`        | LSP client config                           |
| `navigating.lua` | File navigation, folding, session           |
| `searching.lua`  | Search and replace                          |
| `syntax.lua`     | Treesitter parsers and highlighting         |
| `terminal.lua`   | Terminal integration                        |
| `testing.lua`    | Test runners                                |
| `ui.lua`         | Colors, statusline, UI widgets              |
| `utils.lua`      | Shared Lua utilities (e.g. plenary)         |

```lua
-- e.g. in lua/config/plugins/editing.lua:
return {
  -- ... existing entries ...
  require('config.plugins.specs.<plugin-name>'),
}
```

### 3. Install

Run `:Lazy sync` inside Neovim.

---

## Language-specific plugins

Language files in `lua/config/plugins/lang/<lang>.lua` are auto-loaded — no manual registration needed.

Create or edit the file for the relevant language and return a table of plugin specs:

```lua
-- lua/config/plugins/lang/rust.lua
return {
  {
    'stevearc/conform.nvim',
    opts = { formatters_by_ft = { rust = { 'rustfmt' } } },
  },
}
```

Language servers are turned on at the top of the lang file with `vim.lsp.enable('<server>')`, plus
`vim.lsp.config('<server>', { ... })` for settings (see `lang/json.lua`).

When the language server is the formatter, the filetype still needs a non-empty conform entry. Without
one, the `'_'` catch-all in `specs/conform.lua` claims the filetype with `trim_whitespace`, and conform
never falls back to the LSP:

```lua
-- lua/config/plugins/lang/toml.lua
vim.lsp.enable('taplo')

return {
  {
    'stevearc/conform.nvim',
    opts = { formatters_by_ft = { toml = { lsp_format = 'fallback' } } },
  },
}
```
