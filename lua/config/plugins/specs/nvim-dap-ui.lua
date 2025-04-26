---@module 'nvim-dap-ui'

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Focus DAP REPL window when it opens',
  pattern = '\\[dap-repl-*\\]',
  callback = vim.schedule_wrap(function(args)
    local win_id = vim.fn.bufwinid(args.buf)
    vim.api.nvim_set_current_win(win_id)
  end),
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Wrap lines in DAP Watches window',
  pattern = { 'DAP Watches' },
  callback = vim.schedule_wrap(function(args)
    local win_id = vim.fn.bufwinid(args.buf)
    vim.api.nvim_set_option_value('wrap', true, { win = win_id })
  end),
})

-- TODO: calculate appropriate new size each time?
vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Reset nvim-dap-ui window sizes after resizing Neovim window',
  callback = function()
    if require('dap').session() then require('dapui').open({ reset = true }) end
  end,
})

return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'nvim-neotest/nvim-nio',
  },
  opts = function()
    local entire_neovim_ui = vim.api.nvim_list_uis()[1]
    local total_ui_width = entire_neovim_ui.width
    local total_ui_height = entire_neovim_ui.height

    -- Sidebar should be 30% of the total UI width, with a minimum of 40 and a maximum of 80
    local sidebar_width = math.max(40, math.min(110, math.floor(total_ui_width * 0.25)))

    -- Bottom panel should be 30% of the total UI height, with a minimum of 10 and a maximum of 25
    local bottom_panel_height = math.max(10, math.min(25, math.floor(total_ui_height * 0.30)))

    return {
      layouts = {
        {
          elements = {
            { id = 'stacks', size = 0.20 },
            { id = 'scopes', size = 0.45 },
            { id = 'watches', size = 0.20 },
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
