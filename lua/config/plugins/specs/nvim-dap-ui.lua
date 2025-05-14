---@module 'nvim-dap-ui'

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Focus DAP REPL window when it appears',
  pattern = '\\[dap-repl-*\\]',
  callback = vim.schedule_wrap(function(args)
    local win_id = vim.fn.bufwinid(args.buf)
    vim.api.nvim_set_current_win(win_id)
  end),
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Scroll DAP console to bottom window when it appears',
  pattern = '\\[dap-terminal\\]*',
  callback = vim.schedule_wrap(function(args)
    local win_id = vim.fn.bufwinid(args.buf)
    vim.api.nvim_win_set_cursor(win_id, { vim.api.nvim_buf_line_count(args.buf), 0 })
  end),
})

-- FIXME: only if already open (don't open the sidebar every time I open the tmux pane)
-- -- TODO: calculate appropriate new size each time?
-- vim.api.nvim_create_autocmd('VimResized', {
--   desc = 'Reset nvim-dap-ui window sizes after resizing Neovim window',
--   callback = function()
--     if require('dap').session() then require('dapui').open({ reset = true }) end
--   end,
-- })

return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'nvim-neotest/nvim-nio',
  },
  opts = function()
    local entire_neovim_ui = vim.api.nvim_list_uis()[1]
    local total_ui_width = entire_neovim_ui.width
    local total_ui_height = entire_neovim_ui.height

    -- Sidebar should be 30% of the total UI width, with a minimum of 50 and a maximum of 110
    local sidebar_width = math.max(50, math.min(110, math.floor(total_ui_width * 0.3)))

    -- Bottom panel should be 30% of the total UI height, with a minimum of 10 and a maximum of 25
    local bottom_panel_height = math.max(8, math.min(10, math.floor(total_ui_height * 0.15)))

    return {
      layouts = {
        -- {
        --   elements = {
        --     { id = 'stacks', size = 0.25 },
        --     { id = 'scopes', size = 0.35 },
        --     { id = 'watches', size = 0.20 },
        --     { id = 'breakpoints', size = 0.20 },
        --   },
        --   position = 'right',
        --   size = sidebar_width,
        -- },
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
    local dap, dapui = require('dap'), require('dapui')

    dapui.setup(opts)
    -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
