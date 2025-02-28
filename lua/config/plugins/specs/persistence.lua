---@module 'persistence'
-- https://www.lazyvim.org/plugins/util#persistencenvim

return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- only start session saving when an actual file is opened
  opts = { options = vim.opt.sessionoptions:get() },
  keys = {
    { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
    { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
    { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
  },
  init = function()
    require('persistence').load() -- automatically restore session on start
  end,
}
