local set = vim.keymap.set

---@param direction 'next' | 'prev'
---@param severity vim.diagnostic.SeverityFilter | nil
local diagnostic_goto = function(direction, severity)
  local jump_count = direction == 'next' and 1 or -1
  local severity_filter = severity and vim.diagnostic.severity[severity] or nil

  return function() vim.diagnostic.jump({ count = jump_count, severity = severity_filter, float = true }) end
end

-- TODO: does mini.bracketed replace these?
set('n', 'gH', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
set('n', ']d', diagnostic_goto('next'), { desc = 'Next Diagnostic' })
set('n', '[d', diagnostic_goto('next'), { desc = 'Prev Diagnostic' })
set('n', ']e', diagnostic_goto('next', 'ERROR'), { desc = 'Next Error' })
set('n', '[e', diagnostic_goto('prev', 'ERROR'), { desc = 'Prev Error' })
set('n', ']w', diagnostic_goto('next', 'WARN'), { desc = 'Next Warning' })
set('n', '[w', diagnostic_goto('prev', 'WARN'), { desc = 'Prev Warning' })

return {
  require('config.plugins.specs.nvim-dap'),
  require('config.plugins.specs.nvim-dap-ui'),
  require('config.plugins.specs.nvim-dap-view'),
  require('config.plugins.specs.nvim-dap-virtual-text'),
}
