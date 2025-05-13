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

-- NOTE: add back to editing.lua or ui.lua if I ever stop using this plugin
-- autocmd('TextYankPost', {
--   desc = 'Highlight yanked text',
--   callback = function()
--     vim.hl.on_yank({ higroup = 'Visual', timeout = 200 })
--   end,
-- })
