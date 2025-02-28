---@module 'snacks'
-- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md

return {
  'folke/snacks.nvim',
  opts = {
    gitbrowse = {},
  },
  -- stylua: ignore
  keys = {
    { '<leader>go', function() Snacks.gitbrowse.open({ what = 'commit' }) end, desc = 'Open on GitHub', mode = { 'n', 'v' } },
    { '<leader>gO', function() Snacks.gitbrowse.open({ what = 'permalink' }) end, desc = 'Open on GitHub (permalink)', mode = { 'n', 'v' } },
    { '<leader>gy', function() Snacks.gitbrowse.open({ what = 'commit' }) end, desc = 'Open on GitHub', mode = { 'n', 'v' } },
    { '<leader>gY', function() Snacks.gitbrowse.open({ what = 'permalink' }) end, desc = 'Open on GitHub (permalink)', mode = { 'n', 'v' } },
  },
}
