---@module 'trouble'

return {
  'folke/trouble.nvim',
  ---@type trouble.Config
  opts = {
    focus = true, -- focus Trouble window when it opens
    indent_guides = false,
    keys = {
      ['<esc>'] = 'close',
      e = {
        action = function(view) view:filter({ buf = 0 }, { toggle = true }) end,
        desc = 'Toggle current buffer filter',
      },
    },
    modes = {
      diagnostics = {
        -- see: https://github.com/folke/trouble.nvim/blob/main/lua/trouble/sources/diagnostics.lua
        format = '{severity_icon}{message:md} {item.source} {code} {filename} {pos}',
        groups = {
          { 'cmd', format = '{hl:Title}Diagnostics (open editors){hl} {count}' },
        },
      },
      snacks = {
        -- see: https://github.com/folke/trouble.nvim/blob/main/lua/trouble/sources/snacks.lua
        format = '{file_icon} {text:ts} {filename} {pos}',
        groups = {
          { 'cmd', format = '{hl:Title}Snacks{hl} {cmd:Comment} {count}' },
        },
      },
      todo = {
        -- see: https://github.com/folke/todo-comments.nvim/blob/main/lua/trouble/sources/todo.lua
        format = '{todo_icon} {text} {filename} {pos}',
        groups = {
          { 'cmd', format = '{hl:Title}TODO comments (project){hl} {count}' },
        },
        sort = { 'tag', 'filename', 'pos', 'message' },
      },
    },
    auto_close = true, -- close the trouble window when it's empty
    open_no_results = true, -- open the trouble window when there are no results
    warn_no_results = false, -- show a warning when there are no results
  },
  keys = {
    { '<leader>sd', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (open editors)' },
  },
}
