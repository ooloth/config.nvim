---@module 'mini.surround'

-- Add/delete/replace surroundings (brackets, quotes, etc.)

-- EXAMPLE: gsiw' = Surround word under cursor with ''
-- EXAMPLE: cs'` = Change the surround '' to ``
-- EXAMPLE: ds' = Delete the surrounding ''
-- DOCS: https://github.com/echasnovski/mini.surround
-- DOCS: https://www.lazyvim.org/extras/coding/mini-surround

return {
  'echasnovski/mini.surround',
  recommended = true,
  opts = {
    mappings = {
      add = 'gs', -- e.g. gsiw' (normal + visual mode)
      delete = 'ds', -- e.g. ds' (normal mode)
      replace = 'cs', -- e.g. cs'" (normal mode)
      find = '', -- disable
      find_left = '', -- disable
      highlight = '', -- disable
      update_n_lines = '', -- disable
      suffix_last = '', -- disable
      suffix_next = '', -- disable
    },
  },
}
