vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.grepprg = 'rg --vimgrep'
vim.opt.ignorecase = true -- if only lowercase-only, search is case-insensitive
vim.opt.smartcase = true -- if any capital letters, search is case-sensitive

return {
  require('config.plugins.specs.grug-far'),
  require('config.plugins.specs.snacks-picker'),
  -- require 'config.plugins.specs.telescope',
}
