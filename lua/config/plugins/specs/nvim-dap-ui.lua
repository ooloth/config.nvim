---@module 'nvim-dap-ui'

return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'nvim-neotest/nvim-nio',
  },
  keys = {
    { '<leader>du', function() require('dapui').toggle({ reset = true }) end, desc = 'Dap UI' },
    { '<leader>de', function() require('dapui').eval() end, desc = 'Eval', mode = { 'n', 'v' } },
  },
  opts = function()
    local entire_neovim_ui = vim.api.nvim_list_uis()[1]
    local total_ui_width = entire_neovim_ui.width
    local total_ui_height = entire_neovim_ui.height

    -- Sidebar should be 1/3 of the total UI width, with a minimum of 20 and a maximum of 80
    local sidebar_width = math.max(20, math.min(80, math.floor(total_ui_width * 0.33)))

    -- Bottom panel should be 15% of the total UI height, with a minimum of 10 and a maximum of 30
    local bottom_panel_height = math.max(10, math.min(30, math.floor(total_ui_height * 0.15)))

    return {
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
          size = sidebar_width,
        },
        {
          elements = { 'console' },
          position = 'bottom',
          size = bottom_panel_height,
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
    }
  end,
  config = function(_, opts)
    local dap = require('dap')
    local dapui = require('dapui')
    dapui.setup(opts)
    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open({}) end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close({}) end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close({}) end
  end,
}
