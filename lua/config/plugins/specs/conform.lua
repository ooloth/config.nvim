---@module 'conform'

-- TODO: https://www.lazyvim.org/plugins/formatting

local filetypes_to_never_format = {
  ['help'] = true,
  ['gitcommit'] = true,
  ['gitrebase'] = true,
  ['python'] = true, -- formatted by the ruff language server instead
}

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
      ['_'] = function() -- "_" applies to filetypes with no formatter configured
        return filetypes_to_never_format[vim.bo.filetype] and {} or { 'trim_whitespace' }
      end,
    },
    notify_on_error = true,
    -- # Example of using dprint only when a dprint.json file is present
    -- formatters = {
    -- dprint = {
    --   condition = function(ctx)
    --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[]
    --   end,
    -- }
    -- }
  },
}
