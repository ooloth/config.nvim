---@module 'snacks'

return {
  'folke/snacks.nvim',
  opts = {
    lazygit = {
      -- see: https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
      config = {
        gui = {
          nerdFontsVersion = '', -- set to an empty string "" to disable icons
        },
      },
      -- see: https://github.com/folke/snacks.nvim/blob/main/docs/win.md
      win = { height = 0, width = 0 },
    },
  },
  keys = {
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
  },
}
