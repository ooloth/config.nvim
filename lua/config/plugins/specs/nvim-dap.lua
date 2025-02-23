-- TODO: https://www.lazyvim.org/extras/dap/core

local attach_debugger = function()
  -- (re-)reads launch.json if present
  -- FIXME: fails if comments are present in jsonc file (how to parse jsonc properly?)
  if vim.fn.filereadable('.vscode/launch.json') then
    -- TODO: move launch.json config divider here
    -- for _, language in ipairs(js_based_languages) do
    --   require('dap').configurations[language] = {
    --         -- divider before launch.json derived configs
    --     {
    --       name = '↓ launch.json configs ↓',
    --       type = '',
    --       request = 'launch',
    --     },

    local js_based_languages = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'vue' }

    -- TODO: move to typescript.lua?
    require('dap.ext.vscode').load_launchjs(nil, {
      ['pwa-node'] = js_based_languages,
      ['chrome'] = js_based_languages,
      ['pwa-chrome'] = js_based_languages,
    })

    local dap_configurations = require('dap').configurations

    -- override console in all configurations (including launch.json)
    for _, config in ipairs(dap_configurations) do
      config.console = 'integratedTerminal'
      -- config.justMyCode = true  -- NOTE: sometimes it helps to follow code into dependencies we built
    end

    -- TODO: can I move this to python.lua?
    -- override pythonPath in all python configurations
    -- local python_configurations = dap_configurations.python or {}
    -- local python = prefer_venv_executable('python')
    -- for _, config in ipairs(python_configurations) do
    --   config.pythonPath = python
    -- end
  end

  require('dap').continue()
end
return {
  'mfussenegger/nvim-dap',
  recommended = true,
  desc = 'Debugging support. Requires language specific adapters to be configured. (see lang extras)',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
  },

  -- stylua: ignore
  keys = {
    -- { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { '<leader>dd', attach_debugger, desc = 'Start debugger' },
    { '<leader>de', function() require('dapui').eval() end, desc = 'Eval', mode = { 'n', 'v' } },
    { '<leader>dg', function() require('dap').goto_() end, desc = 'Go to line (no execute)' },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { '<leader>dj', function() require('dap').down() end, desc = 'Move down stack' },
    { '<leader>dk', function() require('dap').up() end, desc = 'Move up stack' },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { '<leader>dp', function() require('dap').pause() end, desc = 'Pause' },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    -- { '<leader>dr', function() require('dap').restart() end, desc = 'Restart' },
    { '<leader>ds', function() require('dap').step_over() end, desc = 'Step Over' },
    -- { "<leader>ds", function() require("dap").session() end, desc = "Session" },
    -- { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { '<leader>du', function() require('dapui').toggle({}) end, desc = 'Dap UI' },
    { '<leader>dw', function() require('dapui').elements.watches.add() end, desc = 'Watch symbol under cursor' },
    -- { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    { '<leader>dx', function() require('dap').terminate() end, desc = 'End session' },
  },

  config = function()
    vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

    -- for name, sign in pairs(LazyVim.config.icons.dap) do
    --   sign = type(sign) == 'table' and sign or { sign }
    --   vim.fn.sign_define(
    --     'Dap' .. name,
    --     { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] }
    --   )
    -- end

    -- setup dap config by VsCode launch.json file
    local vscode = require('dap.ext.vscode')
    local json = require('plenary.json')
    vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
  end,
}
