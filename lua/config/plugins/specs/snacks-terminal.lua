---@module 'snacks'

return {
  'folke/snacks.nvim',
  opts = {
    terminal = {},
  },
  keys = {
    { '<c-t>', mode = { 'n', 't' }, function() Snacks.terminal.toggle() end, desc = 'Toggle Terminal' },
  },
}
