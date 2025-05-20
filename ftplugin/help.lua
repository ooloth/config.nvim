vim.cmd('wincmd L') -- move initial help window to the right

vim.opt_local.conceallevel = 0 -- show concealable characters
vim.opt_local.buflisted = false -- exclude from jump list

vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true, silent = true })

-- Move subsequent help windows to the right
vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Help window on right side',
  buffer = 0,
  callback = function() vim.cmd('wincmd L') end,
})
