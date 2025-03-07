return {
  'hankertrix/nerd_column.nvim',
  event = { 'BufEnter' },
  config = function()
    -- https://github.com/hankertrix/nerd_column.nvim?tab=readme-ov-file#default-configuration
    local default_config = require('nerd_column').default_config or {}

    ---@type NerdColumn.Config
    local opts = {
      colour_column = 999, -- default to no colorcolumn appearing
      custom_colour_column = {
        astro = 120, -- TODO: derive from .prettierrc? or what conform.nvim knows?
        javascript = 120, -- TODO: derive from .prettierrc? or what conform.nvim knows?
        javascriptreact = 120, -- TODO: derive from .prettierrc? or what conform.nvim knows?
        lua = 130, -- TODO: derive from .stylua.toml? or what conform.nvim knows?
        python = 120, -- TODO: derive from pyproject.toml? or what conform.nvim knows?
        typescript = 120, -- TODO: derive from .prettierrc? or what conform.nvim knows?
        typescriptreact = 120, -- TODO: derive from .prettierrc? or what conform.nvim knows?
      },
      disabled_file_types = vim.list_extend(default_config.disabled_file_types, {
        'c',
        'css',
        'csv',
        'deno',
        'docker',
        'git',
        'gleam',
        'go',
        'graphql',
        'helm',
        'html',
        'json',
        'markdown',
        'perl',
        'protobuf',
        'pug',
        'rego',
        'ruby',
        'rust',
        'shell',
        'sql',
        'svelte',
        'terraform',
        'text',
        'tmux',
        'toml',
        'vim',
        'vue',
        'xml',
        'yaml',
      }),
      scope = 'line',
    }

    require('nerd_column').setup(opts)
  end,
}
