local set = vim.keymap.set

set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter normal mode' })
set('t', '<c-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
set('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

return {
  require('config.plugins.specs.snacks-terminal'),
}
