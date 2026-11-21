---@module 'conform'

-- TODO: https://www.lazyvim.org/plugins/formatting

local filetypes_to_never_format = {
  ['help'] = true,
  ['gitcommit'] = true,
  ['gitrebase'] = true,
  ['python'] = true, -- an empty list lets the ruff language server format instead (see lang/python.lua)
}

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>rf',
      function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
      mode = '',
      desc = 'Format editor',
    },
  },
  opts = {
    format_on_save = {
      timeout_ms = 500,
      -- Sets lsp_format for every filetype, overriding any lsp_format in a formatters_by_ft entry
      lsp_format = 'fallback',
    },
    formatters_by_ft = {
      -- "_" applies to filetypes with no entry, or an empty one. trim_whitespace counts as a
      -- formatter, so the LSP fallback never runs for them. A language formatted by its LSP needs
      -- its own non-empty entry, such as `toml = { lsp_format = 'fallback' }` (see lang/toml.lua).
      ['_'] = function(bufnr) return filetypes_to_never_format[vim.bo[bufnr].filetype] and {} or { 'trim_whitespace' } end,
    },
    notify_on_error = true,
    formatters = {
      -- See: https://github.com/stevearc/conform.nvim#customizing-formatters
      -- dprint = {
      --   Example of using dprint only when a dprint.json file is present
      --   condition = function(ctx)
      --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[]
      --   end,
      -- }
      prettier = {
        env = {
          -- Support TypeScript config file format
          -- See: https://prettier.io/docs/configuration#typescript-configuration-files
          NODE_OPTIONS = '--experimental-strip-types',
        },
      },
    },
  },
}
