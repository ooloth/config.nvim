vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '.env', '.env.*' },
  callback = function()
    vim.cmd('setlocal ft=dosini')
    vim.cmd('syntax on')
    vim.cmd('set syntax=dosini')
  end,
})

return {}
