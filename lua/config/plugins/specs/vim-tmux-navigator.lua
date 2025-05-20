---@module 'vim-tmux-navigator'

-- navigate vim splits (and tmux panes) with <C-hjkl>

return {
  'christoomey/vim-tmux-navigator',
  event = 'VeryLazy',
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateRight',
    'TmuxNavigateUp',
    'TmuxNavigateDown',
    'TmuxNavigatePrevious',
  },
  keys = {
    { '<c-h>', '<cmd>TmuxNavigateLeft<cr>', mode = { 'n', 'x' } },
    { '<c-l>', '<cmd>TmuxNavigateRight<cr>', mode = { 'n', 'x' } },
    { '<c-k>', '<cmd>TmuxNavigateUp<cr>', mode = { 'n', 'x' } },
    { '<c-j>', '<cmd>TmuxNavigateDown<cr>', mode = { 'n', 'x' } },
    { '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>', mode = { 'n', 'x' } },
  },
}
