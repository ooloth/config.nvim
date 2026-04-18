-- Telescope is a fuzzy finder that comes with a lot of different things that
-- it can fuzzy find! It's more than just a "file finder", it can search
-- many different aspects of Neovim, your workspace, LSP, and more!
--
-- The easiest way to use Telescope, is to start by doing something like:
--  :Telescope help_tags
--
-- After running this command, a window will open up and you're able to
-- type in the prompt window. You'll see a list of `help_tags` options and
-- a corresponding preview of the help.
--
-- Two important keymaps to use while in Telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- Telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

-- See `:help telescope` and `:help telescope.setup()`

-- Support opening multiple files in the same picker session:
-- see: https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-2142669167
local select_one_or_multi = function(prompt_bufnr)
  local actions = require('telescope.actions')
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()

  if not vim.tbl_isempty(multi) then
    actions.close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        if j.lnum ~= nil then
          vim.cmd(string.format('%s +%s %s', 'edit', j.lnum, j.path))
        else
          vim.cmd(string.format('%s %s', 'edit', j.path))
        end
      end
    end
  else
    actions.select_default(prompt_bufnr)
  end
end

return {
  'nvim-telescope/telescope.nvim',
  -- event = 'VimEnter',
  tag = '0.1.8',
  dependencies = {
    -- 'folke/noice.nvim',
    'nvim-lua/plenary.nvim',
    'debugloop/telescope-undo.nvim',
    {
      -- see: https://github.com/danielfalk/smart-open.nvim?tab=readme-ov-file#installation
      'danielfalk/smart-open.nvim',
      branch = '0.2.x',
      dependencies = {
        'kkharji/sqlite.lua',
        'nvim-telescope/telescope-fzy-native.nvim',
      },
    },
  },
  config = function()
    local actions = require('telescope.actions')
    -- local undo_actions = require('telescope-undo.actions')

    require('telescope').setup({
      defaults = {
        layout_config = {
          flex = { width = 0.98, height = 0.97, preview_width = 0.5 },
          horizontal = { width = 0.98, height = 0.97, preview_width = 0.5 },
          prompt_position = 'top',
          vertical = { width = 0.98, height = 0.97, preview_width = 0.5 },
        },
        mappings = {
          i = {
            -- optionally select/deselect multiple files with <Tab>/<S-Tab>, then open all with <CR>
            ['<CR>'] = select_one_or_multi, -- still opens just one file if no multi-selection
            -- ['<esc>'] = actions.close,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-h>'] = actions.cycle_history_prev,
            ['<C-l>'] = actions.cycle_history_next,
          },
        },
        sorting_strategy = 'ascending',
      },
      pickers = {
        help_tags = {
          mappings = {
            i = {
              ['<CR>'] = 'select_vertical',
            },
            n = {
              ['<CR>'] = 'select_vertical',
            },
          },
        },
      },
      extensions = {
        -- ['ui-select'] = {
        --   require('telescope.themes').get_dropdown(),
        -- },
        undo = {
          -- see: https://github.com/debugloop/telescope-undo.nvim?tab=readme-ov-file#configuration
          use_delta = false,
          -- mappings = {
          --   i = {
          --     ['<C-cr>'] = undo_actions.restore,
          --     ['<cr>'] = undo_actions.yank_additions,
          --     ['<S-cr>'] = undo_actions.yank_deletions,
          --   },
          -- },
        },
      },
    })

    -- Load extensions after setup if they're installed
    local telescope = require('telescope')
    pcall(telescope.load_extension('noice'))
    pcall(telescope.load_extension('smart_open'))
    -- pcall(telescope.load_extension, 'ui-select')
    pcall(telescope.load_extension('undo'))

    -- See `:help telescope.builtin`
    local builtin = require('telescope.builtin')
    local extensions = telescope.extensions

    vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Fuzzily search in current buffer' })
    vim.keymap.set('n', '<leader>,', builtin.command_history, { desc = 'Recent commands' })
    vim.keymap.set('n', '<leader>gB', builtin.git_branches, { desc = 'Branches' })
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Commits' })
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Status' })
    vim.keymap.set('n', '<leader>gS', builtin.git_stash, { desc = 'Stashes' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Recent files' })
    vim.keymap.set('n', '<leader>s,', builtin.command_history, { desc = 'Recent commands' })
    vim.keymap.set('n', '<leader>s/', builtin.current_buffer_fuzzy_find, { desc = 'Fuzzily search in current buffer' })
    vim.keymap.set('n', '<leader>sa', builtin.autocommands, { desc = 'Auto commands' })
    vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = 'Commands (plugin)' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
    vim.keymap.set('n', '<leader>se', function() builtin.buffers({ cwd_only = true }) end, { desc = 'Editors' })
    vim.keymap.set('n', '<leader>sf', function() extensions.smart_open.smart_open({ cwd_only = true }) end, { desc = 'Files' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Grep any string' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = 'Marks' })
    vim.keymap.set('n', '<leader>sM', builtin.man_pages, { desc = 'Man pages' })
    vim.keymap.set('n', '<leader>sn', extensions.noice.noice, { desc = 'Notifications (messages)' })
    vim.keymap.set('n', '<leader>so', builtin.vim_options, { desc = 'Options' })
    vim.keymap.set('n', '<leader>sp', builtin.builtin, { desc = 'Telescope pickers' })
    -- <leader>sr = 'Search references' (see lsp.lua)
    vim.keymap.set('n', '<leader>ss', builtin.live_grep, { desc = 'String' })
    vim.keymap.set('n', '<leader>su', extensions.undo.undo, { desc = 'Undo history' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Word under cursor' })
    vim.keymap.set('n', '<leader>sz', builtin.resume, { desc = 'Resume last search' })
    vim.keymap.set(
      'n',
      '<leader>uC',
      function() builtin.colorscheme({ enable_preview = true }) end,
      { desc = 'Colorschemes (with preview)' }
    )
  end,
}
