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
        astro = 100, -- TODO: derive from .prettierrc? or what conform.nvim knows?
        javascript = 100, -- TODO: derive from .prettierrc? or what conform.nvim knows?
        javascriptreact = 100, -- TODO: derive from .prettierrc? or what conform.nvim knows?
        lua = 100, -- TODO: derive from .stylua.toml? or what conform.nvim knows?
        python = 100, -- TODO: derive from pyproject.toml? or what conform.nvim knows?
        typescript = 100, -- TODO: derive from .prettierrc? or what conform.nvim knows?
        typescriptreact = 100, -- TODO: derive from .prettierrc? or what conform.nvim knows?
      },
      disabled_file_types = vim.list_extend(default_config.disabled_file_types, {
        'c',
        'csv',
        'deno',
        'git',
        'helm',
        'html',
        'json',
        'perl',
        'protobuf',
        'vim',
        'xml',
        'yaml',
      }),
      scope = 'line',
    }

    require('nerd_column').setup(opts)
  end,
}
