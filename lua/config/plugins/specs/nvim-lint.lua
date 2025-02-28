---@module 'nvim-lint'

-- TODO: https://www.lazyvim.org/plugins/linting

return {
  'mfussenegger/nvim-lint',
  event = { 'BufNewFile', 'BufRead', 'BufWritePre' },
  opts = {
    linters_by_ft = {
      -- Disable unwanted default linters by filetype
      -- see: https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint.lua#L35-L46
      -- see: https://github.com/mfussenegger/nvim-lint/issues/411#issuecomment-1763172506
      markdown = {}, -- disable vale
      rst = {}, -- disable vale
      text = {}, -- disable vale
    },
  },
  config = function(_, opts)
    local lint = require('lint')

    -- Ensure all linters are merged into the global table (not sure why they aren't otherwise...)
    lint.linters_by_ft = opts.linters_by_ft or {}

    -- Override the default linter settings with any custom ones passed via opts.linters
    for linter, settings in pairs(opts.linters or {}) do
      lint.linters[linter] = settings
    end

    -- Create autocommand to trigger the actual linting
    -- see: https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#usage
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
      group = vim.api.nvim_create_augroup('lint', { clear = true }),
      callback = function() lint.try_lint() end,
    })
  end,
}
