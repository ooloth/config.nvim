# Neovim Config — Agent Notes

## Checks

Run these before and after making changes to verify nothing is broken:

```bash
# Check formatting (must pass before committing)
stylua --check .

# Load the config module headlessly to catch Lua errors
nvim --headless -u NONE --cmd "set rtp^=." -c "lua require('config')" -c "qa"
```

If `stylua --check .` reports violations, fix them with `stylua .`.

## Docs

| Playbook | Description |
| -------- | ----------- |
| [Add a new plugin](docs/playbooks/add-new-plugin.md) | Create a spec file and register it in the right category |
