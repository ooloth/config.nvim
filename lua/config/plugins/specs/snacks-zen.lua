---@module 'snacks'

return {
  'folke/snacks.nvim',
  opts = {
    zen = {}, -- see: https://github.com/folke/snacks.nvim/blob/main/docs/zen.md#%EF%B8%8F-config
    styles = {
      zoom_indicator = {
        text = ' 󰊓 ZOOMED 󰊓   ',
        minimal = false,
      },
    },
  },
  keys = {
    { '<leader>em', function() Snacks.zen.zoom() end, desc = 'Maximize (toggle)', mode = { 'n', 'v' } },
    { '<leader>uz', function() Snacks.zen.zen() end, desc = 'Zen mode (toggle)', mode = { 'n', 'v' } },
    { '<leader>wm', function() Snacks.zen.zoom() end, desc = 'Maximize (toggle)', mode = { 'n', 'v' } },
  },
}
