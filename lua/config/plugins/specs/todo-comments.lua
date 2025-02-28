---@module 'todo-comments'

return {
  'folke/todo-comments.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'folke/trouble.nvim',
  },
  opts = {
    -- see: https://github.com/folke/todo-comments.nvim?tab=readme-ov-file#%EF%B8%8F-configuration
    gui_style = {
      fg = 'NONE', -- The gui style to use for the fg highlight group.
      bg = 'NONE', -- The gui style to use for the bg highlight group.
    },
    highlight = {
      after = 'fg',
      keyword = 'fg',
      multiline = true, -- highlight the entire block?
    },
    signs = false,
  },
  keys = {
    { ']t', function() require('todo-comments').jump_next() end, desc = 'Next todo (editor)' },
    { '[t', function() require('todo-comments').jump_prev() end, desc = 'Previous todo (editor)' },
    { '<leader>st', '<cmd>Trouble todo toggle filter = {tag = {FIXME,FIX,TODO,WARN}}<cr>', desc = 'Todos' },
  },
}
