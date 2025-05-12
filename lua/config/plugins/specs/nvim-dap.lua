---@module 'nvim-dap'

-- TODO: warn if no active session?
-- TODO: create variant to be used in the repl rather than the editor?
---Start the debugger, pause at a breakpoint, select a dataframe, and run leader-dv
---See: https://github.com/Willem-J-an/visidata.nvim/blob/master/lua/visidata.lua
---See: https://www.reddit.com/r/neovim/comments/13nw1mq/comment/jl1w7is/
local send_selection_to_visidata_in_external_terminal = function()
  local function get_visual_selection()
    local _, line_start, col_start = unpack(vim.fn.getpos('v'))
    local _, line_end, col_end = unpack(vim.fn.getpos('.'))
    local selection = vim.api.nvim_buf_get_text(0, line_start - 1, col_start - 1, line_end - 1, col_end, {})
    return selection
  end

  local selected_dataframe = get_visual_selection()[1]

  local dap = require('dap')
  dap.repl.execute('import subprocess')

  -- TODO: add support for json alternative:
  -- subprocess.run(["vd", "-f", "json", "-"], input=json.dumps(' .. selected_list_of_dicts .. '), text=True)

  dap.repl.execute('subprocess.run(["vd", "-f", "csv", "-"], input=' .. selected_dataframe .. '.to_csv(index=False), text=True)')
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
    { '<leader>dv', send_selection_to_visidata_in_external_terminal, desc = 'Visidata (send selected dataframe)', mode={ 'v' } },
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
      args = { 'split-window', '-d', '-v', '-l', '15%', '-c', '.' },
      -- args = { 'new-window', '-a' },
    }

    -- Hook to modify relevant configuration when starting the debugger
    -- Use tmux pane as external terminal without impacting colleagues who prefer their integrated IDE terminal
    dap.listeners.on_config['override_console'] = function(config)
      config.console = 'externalTerminal'
      config.external_terminal = dap.defaults.fallback.external_terminal
      return config
    end
  end,
}
