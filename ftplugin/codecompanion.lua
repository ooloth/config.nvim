-- Move subsequent codecompanion windows to the right
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Move CodeCompanion chat window to far right',
  buffer = 0,
  callback = function() vim.cmd('wincmd L') end,
})
