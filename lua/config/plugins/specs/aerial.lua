return {
  'stevearc/aerial.nvim',
  opts = {
    -- Jump to symbol in source window when the cursor moves
    autojump = true,

    close_on_select = true,

    -- Use symbol tree for folding. Set to true or false to enable/disable
    -- Set to "auto" to manage folds if your previous foldmethod was 'manual'
    -- This can be a filetype map (see :help aerial-filetype-map)
    manage_folds = true,

    -- When you fold code with za, zo, or zc, update the aerial tree as well.
    -- Only works when manage_folds = true
    link_folds_to_tree = true,

    post_jump_cmd = 'normal! zt',

    -- Show box drawing characters for the tree hierarchy
    show_guides = false,

    nav = {
      border = 'rounded',
      max_height = 0.9,
      min_height = { 10, 0.1 },
      max_width = 0.5,
      min_width = { 0.2, 20 },
      win_opts = {
        cursorline = true,
        winblend = 10,
      },
      -- Jump to symbol in source window when the cursor moves
      autojump = true,
      -- Show a preview of the code in the right column, when there are no child symbols
      preview = false,
      -- Keymaps in the nav window
      keymaps = {
        ['<CR>'] = 'actions.jump',
        ['<C-v>'] = 'actions.jump_vsplit',
        ['<C-s>'] = 'actions.jump_split',
        ['h'] = 'actions.left',
        ['l'] = 'actions.right',
        ['<esc>'] = 'actions.close',
        ['q'] = 'actions.close',
      },
    },
  },
  -- config = function()
  --   require('aerial').snacks_picker({
  --     layout = {
  --       preset = 'dropdown',
  --       preview = false,
  --     },
  --   })
  -- end,
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '<leader>ss', '<cmd>AerialNavToggle<cr>', desc = 'Symbols (editor)' },
  },
}
