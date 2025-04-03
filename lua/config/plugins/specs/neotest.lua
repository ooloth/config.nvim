---@module 'neotest'

-- TODO: https://tamerlan.dev/setting-up-a-testing-environment-in-neovim/
-- TODO: https://www.lazyvim.org/extras/test/core

return {
  'nvim-neotest/neotest',
  event = 'VeryLazy',
  ft = { 'go', 'rust', 'python', 'typescript', 'javascript' },
  dependencies = {
    'antoinemadec/FixCursorHold.nvim',
    'nvim-neotest/nvim-nio',
    'nvim-treesitter/nvim-treesitter',
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<leader>ta', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'Run All Test Files' },
    { '<leader>td', function() require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' }) end, desc = 'Debug Nearest' },
    { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Run Last' },
    {
      '<leader>to',
      function() require('neotest').output.open({ enter = false, auto_close = true, short = true }) end,
      desc = 'Show Output',
    },
    { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Toggle Output Panel' },
    { '<leader>tr', function() require('neotest').run.run() end, desc = 'Run Nearest' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Toggle Summary' },
    { '<leader>tt', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Run File' },
    { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand('%')) end, desc = 'Toggle Watch' },
    { '<leader>tx', function() require('neotest').run.stop() end, desc = 'Stop' },
  },
  opts = {
    diagnostic = {
      enabled = false,
    },
    floating = {
      border = 'rounded',
      max_height = 0.9,
      max_width = 0.9,
    },
    output = {
      enabled = true,
      open_on_run = 'short',
    },
    quickfix = {
      open = function() require('trouble').open({ mode = 'quickfix', focus = false }) end,
    },
    status = {
      virtual_text = true,
    },
    strategies = {
      integrated = {
        height = 40,
        width = 120,
      },
    },
    summary = {
      animated = true,
      count = true,
      enabled = true,
      expand_errors = true,
      follow = true,
      mappings = {
        attach = 'a',
        clear_marked = 'M',
        clear_target = 'T',
        debug = 'd',
        debug_marked = 'D',
        expand = { '<CR>', '<2-LeftMouse>' },
        expand_all = 'e',
        help = '?',
        jumpto = 'i',
        mark = 'm',
        next_failed = 'J',
        output = 'o',
        prev_failed = 'K',
        run = 'r',
        run_marked = 'R',
        short = 'O',
        stop = 'u',
        target = 't',
        watch = 'w',
      },
      open = 'botright vsplit | vertical resize 50',
    },
  },
  config = function(_, opts)
    -- see: https://github.com/nvim-neotest/neotest-python/issues/52#issuecomment-1676568667
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace('neotest')

    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
          return message
        end,
      },
    }, neotest_ns)

    require('neotest').setup(opts)
  end,
}
