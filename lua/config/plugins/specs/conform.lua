-- TODO: https://www.lazyvim.org/plugins/formatting
-- TODO: https://www.lazyvim.org/extras/formatting/prettier

-- see: https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/prettier.lua
-- see: https://www.lazyvim.org/extras/formatting/prettier

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>rf',
      function() require('conform').format({ async = true, lsp_fallback = true }) end,
      mode = '',
      desc = 'Format editor',
    },
  },
  opts = {
    -- see: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#setup
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      -- use the "_" filetype to run formatters on filetypes that don't have other formatters configured.
      ['_'] = { 'trim_whitespace' },
    },
  },
}
