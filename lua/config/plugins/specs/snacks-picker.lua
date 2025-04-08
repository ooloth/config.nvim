---@module 'snacks'

return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    picker = {
      -- see: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
      actions = {
        -- see: https://www.lazyvim.org/extras/editor/snacks_picker#snacksnvim-1
        trouble_open = function(...) return require('trouble.sources.snacks').actions.trouble_open.action(...) end,
      },
      formatters = {
        file = {
          filename_first = false, -- display filename before the file path
          truncate = 80, -- truncate the file path to (roughly) this length
        },
      },
      layouts = {
        -- see: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-layouts
        default = {
          layout = { height = 0, width = 0 },
        },
        -- TODO: customize dimensions of special layouts that feel too small
      },
      sources = {
        -- NOTE: keep this example for how to customize a source
        -- grep = {
        --   layout = { preset = 'vertical', layout = { height = 0, width = 0 } },
        -- },
      },
      win = {
        input = {
          keys = {
            ['<c-h>'] = { 'history_forward', mode = { 'i', 'n' } },
            ['<c-l>'] = { 'history_back', mode = { 'i', 'n' } },
            ['<c-t>'] = { 'trouble_open', mode = { 'n', 'i' } }, -- send results to Trouble
          },
        },
      },
    },
  },
  keys = {
    { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto definition' },
    { 'gD', function() Snacks.picker.lsp_declarations() end, desc = 'Goto declaration' },
    { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto implementation' },
    { 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References' },
    { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto t[y]pe definition' },
    {
      '<leader><space>',
      function() Snacks.picker.smart({ filter = { cwd = true } }) end,
      desc = 'Smart find recent files',
    },
    { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>,', function() Snacks.picker.command_history() end, desc = 'Command history' },
    { '<leader>e/', function() Snacks.picker.lines() end, desc = 'Search lines' },
    { '<leader>gB', function() Snacks.picker.git_branches() end, desc = 'Git branches' },
    { '<leader>gd', function() Snacks.picker.git_diff() end, desc = 'Git diff (hunks)' },
    { '<leader>gla', function() Snacks.picker.git_log() end, desc = 'All commits' },
    { '<leader>glf', function() Snacks.picker.git_log_file() end, desc = 'File commits' },
    { '<leader>gll', function() Snacks.picker.git_log_line() end, desc = 'Line commits' },
    { '<leader>gs', function() Snacks.picker.git_stash() end, desc = 'Git stashes' },
    { '<leader>s,', function() Snacks.picker.commands() end, desc = 'Commands' },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers' },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = 'Search history' },
    { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds' },
    { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command history' },
    -- NOTE: leader-sd is used by trouble.nvim to open diagnostics in Trouble's quickfix view
    { '<leader>se', function() Snacks.picker.buffers() end, desc = 'Editors (files)' },
    { '<leader>sE', function() Snacks.picker.grep_buffers() end, desc = 'Editors (text)' },
    {
      '<leader>sf',
      function() Snacks.picker.files({ hidden = true, ignored = true }) end,
      desc = 'Files',
    },
    { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help pages' },
    { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights' },
    { '<leader>si', function() Snacks.picker.icons() end, desc = 'Icons & Emoji' },
    { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
    -- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
    { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man pages' },
    { '<leader>sp', function() Snacks.picker() end, desc = 'Pickers' },
    -- { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { '<leader>sr', function() Snacks.picker.recent({ filter = { cwd = true } }) end, desc = 'Recent files' },
    { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'Symbols (editor)' },
    { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'Symbols (project)' },
    -- TODO: '<leader>st' = 'Todos' (see todo-comment.lua)
    -- { "<leader>st", function() Snacks.explorer() end, desc = "File tree" },
    { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo history' },
    {
      '<leader>sw',
      function() Snacks.picker.grep_word() end,
      desc = 'Visual selection or cursor word',
      mode = { 'n', 'x' },
    },
    { '<leader>sz', function() Snacks.picker.resume() end, desc = 'Resume' },
    { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
  },
}
