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

local function start_if_needed_and_run_to_cursor()
  local dap = require('dap')

  if not dap.session() then
    dap.set_breakpoint()
    dap.continue()
    return
  end

  dap.run_to_cursor()
end

---@param element 'breakpoints' | 'console' | 'repl' | 'scopes' | 'stacks' | 'watches'
local function toggle_element(element)
  -- TODO: prevent from getting out of sync with layouts config?
  local layouts_index_by_element = {
    breakpoints = 1,
    console = 2,
    repl = 3,
    scopes = 4,
    stacks = 5,
    watches = 6,
  }

  local dapui = require('dapui')

  -- set lazy redraw
  vim.cmd('set lazyredraw')
  for elem, layouts_index in pairs(layouts_index_by_element) do
    if elem == element then
      dapui.toggle({ layout = layouts_index, reset = true })
    else
      dapui.close({ layout = layouts_index })
    end
  end
  -- reset redraw
  vim.cmd('set nolazyredraw')
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
    { "<leader>dc", start_if_needed_and_run_to_cursor, desc = "Run to Cursor" },
    { "<leader>dd", function() require("dap").continue() end, desc = "Start/continue" },
    { '<leader>de', function() require('dapui').eval(nil, { enter = true }) end, desc = 'Evaluate', mode = { 'n', 'v' } },
    { '<leader>dfb', function() require('dapui').float_element('breakpoints', { enter = true, position = 'center', height = 15, width = 60 }) end, desc = 'Breakpoints' },
    { '<leader>dfr', function() require('dapui').float_element('repl', { enter = true, position = 'center', height = 1000, width = 1000 }) end, desc = 'REPL' }, 
    { '<leader>dfs', function() require('dapui').float_element('stacks', { enter = true, position = 'center', height = 15, width = 60 }) end, desc = 'Stack frames (stacks)' }, 
    { '<leader>dft', function() require('dapui').float_element('console', { enter = true, position = 'center', height = 1000, width = 1000 }) end, desc = 'Terminal' }, 
    { '<leader>dfv', function() require('dapui').float_element('scopes', { enter = true, position = 'center', height = 1000, width = 1000 }) end, desc = 'Variables (scopes)' }, 
    { '<leader>dfw', function() require('dapui').float_element('watches', { enter = true, position = 'center', height = 15, width = 60 }) end, desc = 'Watch expressions' }, 
    { '<leader>dg', function() require('dap').goto_() end, desc = 'Go to line (no execute)' },
    { '<leader>dh', function() require('dapui').eval(nil, { enter = true }) end, desc = 'Hover', mode = { 'n', 'v' } },
    { '<leader>di', function() require('nvim-dap-virtual-text').toggle() end, desc = 'Inlay hints (toggle)' },
    { '<leader>dj', function() require('dap').down() end, desc = 'Move down stack' },
    { '<leader>dk', function() require('dap').up() end, desc = 'Move up stack' },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { '<leader>dp', function() require('dap').pause() end, desc = 'Pause' },
    { '<leader>dr', function() toggle_element('repl') end, desc = 'REPL (toggle)' },
    { '<leader>dR', function() require('dap').restart() end, desc = 'Restart' },
    { "<leader>dsi", function() require("dap").step_into() end, desc = "Step Into" },
    { '<leader>dso', function() require('dap').step_over() end, desc = 'Step Over' },
    { "<leader>dsu", function() require("dap").step_out() end, desc = "Step Out" },
    { '<leader>dt', function() toggle_element('console') end, desc = 'Terminal (toggle)' },
    { '<leader>dub', function() toggle_element('breakpoints') end, desc = 'Breakpoints (toggle)' },
    { '<leader>dur', function() toggle_element('repl') end, desc = 'REPL (toggle)' },
    { '<leader>dus', function() toggle_element('stacks') end, desc = 'Stacks by thread (toggle)' },
    { '<leader>dut', function() toggle_element('console') end, desc = 'Terminal (toggle)' },
    { '<leader>duv', function() toggle_element('scopes') end, desc = 'Variables (toggle)' },
    { '<leader>duw', function() toggle_element('watches') end, desc = 'Watches (toggle)' },
    -- { '<leader>du', function() require('dapui').toggle({ reset = true }) end, desc = 'Dap UI (toggle)' },
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
    dap.listeners.on_config['override-console'] = function(config)
      config.console = 'integratedTerminal'
      -- config.external_terminal = dap.defaults.fallback.external_terminal
      return config
    end

    dap.listeners.after['event_stopped']['center-cursor-line'] = function(session, body)
      -- When a breakpoint is reached, center the cursor line
      if body.reason:find('breakpoint') or body.reason:find('exception') then vim.cmd('normal! zz') end
    end
  end,
}
