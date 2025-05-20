vim.opt_local.buflisted = false -- exclude from jump list

vim.keymap.set('n', '<esc>', '<cmd>close<cr>', { buffer = true, silent = true })
vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true, silent = true })
