---@module 'nvim-treesitter'

-- Highlight, edit, and navigate code

-- DOCS: `:h nvim-treesitter`
-- DOCS: https://github.com/nvim-treesitter/nvim-treesitter
-- DOCS: https://www.lazyvim.org/plugins/treesitter
-- DOCS: https://neovim.io/doc/user/treesitter.html

return {
  'nvim-treesitter/nvim-treesitter',
  version = false, -- last release is way too old and doesn't work on Windows
  event = { 'BufEnter', 'VeryLazy' },
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- sets main module (the module to call .setup(opts) on)
  cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  opts_extend = { 'ensure_installed' }, -- extend this list-like option when merging configs (see: https://github.com/folke/lazy.nvim/discussions/1706#discussioncomment-10268907)
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    auto_install = true, -- install missing parsers when entering buffer
    -- The following parsers MUST always be installed to override the versions that ship with neovim and avoid errors
    -- https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
    ensure_installed = { 'c', 'lua', 'markdown', 'markdown_inline', 'query', 'regex', 'vim', 'vimdoc' },
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      -- see: https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#incremental-selection
      -- see `:h nvim-treesitter-incremental-selection-mod`
      enable = true,
      keymaps = {
        init_selection = '<cr>',
        node_incremental = '<cr>',
        node_decremental = '<bs>',
      },
    },
    textobjects = {
      move = {
        -- see: https://github.com/nvim-treesitter/nvim-treesitter-textobjects?tab=readme-ov-file#text-objects-move
        enable = true,
        goto_next_start = { [']f'] = '@function.outer' },
        goto_next_end = { [']F'] = '@function.outer' },
        goto_previous_start = { ['[f'] = '@function.outer' },
        goto_previous_end = { ['[F'] = '@function.outer' },
      },
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = { query = '@function.outer', desc = 'Outer function' },
          ['if'] = { query = '@function.inner', desc = 'Inner function' },
          ['ac'] = { query = '@class.outer', desc = 'Outer class' },
          ['ic'] = { query = '@class.inner', desc = 'Inner class' },
          -- You can also use captures from other query groups like `locals.scm`
          ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
        },
      },
    },
  },
  init = function(plugin)
    -- PERF: add nvim-treesitter queries to the rtp and its custom query predicates early
    -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which no longer trigger the **nvim-treesitter** module to be loaded in time.
    -- Luckily, the only things that those plugins need are the custom queries, which we make available during startup.
    require('lazy.core.loader').add_to_rtp(plugin)
    require('nvim-treesitter.query_predicates')
  end,
}
