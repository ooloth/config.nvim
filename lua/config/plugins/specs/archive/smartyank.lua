---@module 'smartyank'

return {
  'ibhagwan/smartyank.nvim',
  opts = {
    highlight = {
      enabled = true, -- highlight yanked text
      higroup = 'Visual', -- highlight group of yanked text
      timeout = 200, -- timeout for clearing the highlight
    },
  },
}
