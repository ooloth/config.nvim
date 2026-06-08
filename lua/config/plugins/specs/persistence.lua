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
    -- Defer past lazy.nvim's synchronous setup so all event listeners (BufRead,
    -- FileType, etc.) are registered before the session opens buffers. Without
    -- this, treesitter highlighting and LSP don't attach on startup because their
    -- autocmds don't exist yet when the session fires these events during lazy's
    -- init phase. vim.schedule runs after the current call stack (including all of
    -- lazy.setup()) unwinds, so all listeners are wired up before the session loads.
    vim.schedule(function() require('persistence').load() end)
  end,
}
