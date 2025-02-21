-- TODO: https://www.lazyvim.org/plugins/formatting

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
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace' }, -- "_" applies to all filetypes
    },
    notify_on_error = true,
  },
}
