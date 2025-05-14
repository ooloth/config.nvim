---@module 'mini.surround'

-- Surround selection with 'S' in visual mode
vim.keymap.set('v', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

return {
  'echasnovski/mini.surround',
  recommended = true,
  opts = {
    mappings = {
      add = 'gsa', -- e.g. gsaiw' (normal + visual mode) Add surrounding in Normal and Visual modes
      delete = 'gsd', -- e.g. gsd' (normal mode)
      replace = 'gsr', -- e.g. gsr'" (normal mode)
      -- add = 'gs', -- e.g. gsiw' (normal + visual mode)
      -- delete = 'ds', -- e.g. ds' (normal mode)
      -- replace = 'cs', -- e.g. cs'" (normal mode)
      find = '', -- disable
      find_left = '', -- disable
      highlight = '', -- disable
      update_n_lines = '', -- disable
      suffix_last = '', -- disable
      suffix_next = '', -- disable
    },
  },
}
