return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {
    modes = {
      char = {
        enabled = false,
      },
    },
  },
  keys = {
    { 'gj', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Jump (with flash)' },
  },
}
