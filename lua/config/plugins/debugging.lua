local get_cursor_expression_or_selection = require('config.util').get_cursor_expression_or_selection

local set = vim.keymap.set

--- @type table<string, fun(expression: string): string[]>
local print_to_console_for_ft = {
  python = function(expr)
    local terminal_width = vim.env.COLUMNS or 80

    return {
      'print("")',
      'print("=" * ' .. vim.o.columns - 2 .. ')',
      'print(f"{' .. expr .. ' =}")',
      'print("=" * ' .. vim.o.columns - 2 .. ')',
      'print("")',
    }
  end,
  javascript = function(expr) return { 'console.log(' .. expr .. ')' } end,
  lua = function(expr) return { 'vim.notify(vim.inspect(' .. expr .. '))' } end,
}

vim.keymap.set({ 'n', 'x' }, '<leader>p', function()
  local ft = vim.bo.filetype

  if not print_to_console_for_ft[ft] then
    vim.notify('No print function defined for filetype: ' .. ft, vim.log.levels.WARN)
    return
  end

  local expression = get_cursor_expression_or_selection()
  if expression == nil or expression == '' then
    vim.notify('No expression selected', vim.log.levels.WARN)
    return
  end

  -- Generate the print statement
  local print_statement = print_to_console_for_ft[ft](expression)

  -- Get the current cursor position
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  -- Get the current line's indentation
  local indent_level = vim.fn.indent(row)
  local indent = string.rep(' ', indent_level)

  -- Prepend the indentation to each line in the print_statement array
  for i, line in ipairs(print_statement) do
    print_statement[i] = indent .. line
  end

  -- Insert the indented lines below the current cursor position
  vim.api.nvim_buf_set_lines(0, row, row, false, print_statement)
end, { desc = 'Print to console' })

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
  require('config.plugins.specs.nvim-dap-virtual-text'),
}
