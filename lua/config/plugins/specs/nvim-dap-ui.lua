---@module 'nvim-dap-ui'

return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'nvim-neotest/nvim-nio',
  },
  keys = {
    { '<leader>du', function() require('dapui').toggle({}) end, desc = 'Dap UI' },
    { '<leader>de', function() require('dapui').eval() end, desc = 'Eval', mode = { 'n', 'v' } },
  },
  opts = {
    -- see: https://github.com/rcarriga/nvim-dap-ui/blob/master/lua/dapui/config/init.lua
    -- controls = {
    --   element = 'repl',
    --   enabled = false,
    --   icons = {
    --     pause = '⏸',
    --     play = '▶',
    --     step_into = '⏎',
    --     step_over = '⏭',
    --     step_out = '⏮',
    --     step_back = 'b',
    --     run_last = '▶▶',
    --     terminate = '⏹',
    --     disconnect = '⏏',
    --   },
    -- },
    -- element_mappings = {
    --   scopes = {},
    --   watches = {},
    --   stacks = {},
    --   breakpoints = {},
    --   console = {},
    --   repl = {},
    -- },
    -- expand_lines = true,
    -- floating = {
    --   border = 'single',
    --   mappings = {
    --     close = { 'q', '<Esc>' },
    --   },
    -- },
    -- icons = { collapsed = '', current_frame = '', expanded = '' },
    -- icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    layouts = {
      {
        elements = {
          { id = 'stacks', size = 0.25 },
          { id = 'scopes', size = 0.45 },
          { id = 'watches', size = 0.15 },
          { id = 'breakpoints', size = 0.15 },
        },
        position = 'right',
        size = 70,
      },
      {
        elements = { 'console', 'repl' },
        position = 'bottom',
        size = 16,
      },
    },
    -- mappings = {
    --   edit = 'e',
    --   expand = { 'l', '<CR>', '<2-LeftMouse>' },
    --   open = 'o',
    --   remove = 'd',
    --   repl = 'r',
    --   toggle = 't',
    -- },
    -- render = {
    --   indent = 1,
    --   max_value_lines = 1000,
    -- },
  },
  config = function(_, opts)
    local dap = require('dap')
    local dapui = require('dapui')
    dapui.setup(opts)
    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end
  end,
}
