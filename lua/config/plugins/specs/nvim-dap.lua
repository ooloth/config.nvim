---@module 'nvim-dap'

local function get_visual_selection()
  local mode = vim.fn.mode()
  if mode == 'v' then
    local _, line_start, col_start = unpack(vim.fn.getpos('v'))
    local _, line_end, col_end = unpack(vim.fn.getpos('.'))

    -- Normalize the positions (support selecting in reverse)
    if line_start > line_end or (line_start == line_end and col_start > col_end) then
      line_start, line_end = line_end, line_start
      col_start, col_end = col_end, col_start
    end

    local selection = vim.api.nvim_buf_get_text(0, line_start - 1, col_start - 1, line_end - 1, col_end, {})
    return selection[1]
  else
    return vim.fn.expand('<cexpr>')
  end
end

-- TODO: create variant to be used in the repl rather than the editor?
---Start the debugger, pause at a breakpoint, select a dataframe or list of dicts, and run leader-dvc or leader-dvj
---See: https://github.com/Willem-J-an/visidata.nvim/blob/master/lua/visidata.lua
---See: https://www.reddit.com/r/neovim/comments/13nw1mq/comment/jl1w7is/
---@param format 'csv' | 'json'
local send_selection_to_visidata_in_new_tmux_window = function(format)
  local selection = get_visual_selection()

  local dap = require('dap')
  dap.repl.execute('import subprocess')

  if format == 'json' then
    dap.repl.execute([[
import json, os, tempfile
with tempfile.NamedTemporaryFile(delete=False, mode='w', suffix='.json') as tmpfile:
    tmpfile.write(json.dumps(]] .. selection .. [[))
    tmpfile_path = tmpfile.name
os.system(f"tmux new-window 'sh -c \"vd {tmpfile_path}; rm {tmpfile_path}\"'")
]])
  else
    -- TODO: support polars as well as pandas (used below)
    -- TODO: write to parquet instead of csv?
    -- TODO: infer types when opening?
    dap.repl.execute([[
import os, tempfile
with tempfile.NamedTemporaryFile(delete=False, mode='w', suffix='.csv') as tmpfile:
    tmpfile.write(]] .. selection .. [[.to_csv(index=False))
    tmpfile_path = tmpfile.name
os.system(f"tmux new-window 'sh -c \"vd {tmpfile_path}; rm {tmpfile_path}\"'")
]])
  end
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    {
      'rcarriga/cmp-dap',
      dependencies = { 'hrsh7th/nvim-cmp' },
      config = function()
        -- Add completion support in dap-repl, dapui_watches, and dapui_hover buffers
        require('cmp').setup({
          enabled = function() return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer() end,
        })

        require('cmp').setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
          sources = {
            { name = 'dap' },
          },
        })
      end,
    },
  },

  -- stylua: ignore
  keys = {
    -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>dc", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dd", function() require("dap").continue() end, desc = "Start/continue" },
    { '<leader>de', function() require('dapui').eval(nil, { enter = true }) end, desc = 'Evaluate', mode = { 'n', 'v' } },
    { '<leader>dfb', function() require('dapui').float_element('breakpoints', {enter=true, position='center', height=20, width=100}) end, desc = 'Breakpoints' }, 
    { '<leader>dfc', function() require('dapui').float_element('console', {enter=true, position='center', height=1000, width=1000}) end, desc = 'Console (integrated terminal)' }, 
    { '<leader>dfr', function() require('dapui').float_element('repl', {enter=true, position='center', height=1000, width=1000}) end, desc = 'REPL' }, 
    { '<leader>dfs', function() require('dapui').float_element('stacks', {enter=true, position='center', height=20, width=100}) end, desc = 'Stack frames (stacks)' }, 
    { '<leader>dfv', function() require('dapui').float_element('scopes', {enter=true, position='center', height=1000, width=1000}) end, desc = 'Variables (scopes)' }, 
    { '<leader>dfw', function() require('dapui').float_element('watches', {enter=true, position='center', height=20, width=100}) end, desc = 'Watch expressions' }, 
    { '<leader>dg', function() require('dap').goto_() end, desc = 'Go to line (no execute)' },
    { '<leader>dh', function() require('dapui').eval(nil, { enter = true }) end, desc = 'Hover', mode = { 'n', 'v' } },
    { '<leader>di', function() require('nvim-dap-virtual-text').toggle() end, desc = 'Inlay hints (toggle)' },
    { '<leader>dj', function() require('dap').down() end, desc = 'Move down stack' },
    { '<leader>dk', function() require('dap').up() end, desc = 'Move up stack' },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { '<leader>dp', function() require('dap').pause() end, desc = 'Pause' },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { '<leader>dR', function() require('dap').restart() end, desc = 'Restart' },
    { "<leader>dsi", function() require("dap").step_into() end, desc = "Step Into" },
    { '<leader>dso', function() require('dap').step_over() end, desc = 'Step Over' },
    { "<leader>dsu", function() require("dap").step_out() end, desc = "Step Out" },
    { '<leader>du', function() require('dapui').toggle({ reset = true }) end, desc = 'Dap UI (toggle)' },
    { '<leader>dvc', function() send_selection_to_visidata_in_new_tmux_window('csv') end, desc = 'Visidata (dataframe)', mode={ 'n', 'v' } },
    { '<leader>dvj', function() send_selection_to_visidata_in_new_tmux_window('json') end, desc = 'Visidata (list of dicts)', mode={ 'n', 'v' } },
    { '<leader>dw', function() require('dapui').elements.watches.add() end, desc = 'Watch symbol under cursor' },
    { '<leader>dx', function() require('dap').terminate() end, desc = 'End session' },
  },

  config = function()
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    -- see: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua#L32
    ---@type table<string, string[]>
    local icons = {
      DapStopped = { '󰁕 ', 'DiagnosticWarn', 'DapStoppedLine' },
      DapBreakpoint = { ' ' },
      DapBreakpointCondition = { ' ' },
      DapBreakpointRejected = { ' ', 'DiagnosticError' },
      DapLogPoint = { '.>' },
    }

    for name, sign in pairs(icons) do
      local text = sign[1]
      local texthl = sign[2] or 'DiagnosticInfo'
      local linehl = sign[3] or ''
      vim.fn.sign_define(name, { text = text, texthl = texthl, linehl = linehl, numhl = linehl })
    end

    -- Set up dap configs using vscode launch.json files
    -- NOTE: if launch.json options don't appear, check for a trailing comma or other invalid json (dap parses as json, not jsonc)
    -- See: https://github.com/mfussenegger/nvim-dap/issues/1442
    local vscode = require('dap.ext.vscode')
    local json = require('plenary.json')
    vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end

    -- Use tmux as external terminal
    local dap = require('dap')
    dap.defaults.fallback.external_terminal = {
      command = 'tmux',
      args = { 'split-window', '-d', '-v', '-l', '20%', '-c', '.' },
    }

    -- Hook to modify relevant configuration when starting the debugger
    -- Use tmux pane as external terminal without impacting colleagues who prefer their integrated IDE terminal
    dap.listeners.on_config['override_console'] = function(config)
      config.console = 'integratedTerminal'
      -- config.external_terminal = dap.defaults.fallback.external_terminal
      return config
    end
  end,
}
