---@module 'snacks'
-- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md

return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    notifier = {},
    notify = {},
  },
  keys = {
    { '<leader>n', function() Snacks.notifier.show_history() end, desc = 'Notification History' },
    { '<leader>un', function() Snacks.notifier.hide() end, desc = 'Dismiss All Notifications' },
  },
}
