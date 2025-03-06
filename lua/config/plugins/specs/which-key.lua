---@module 'which-key'

-- DOCS: https://github.com/folke/which-key.nvim
-- DOCS: https://www.lazyvim.org/plugins/editor#which-keynvim
-- TODO: `:checkhealth which-key`
-- TODO: distribute in relevant files with wk.add()?

return {
  'folke/which-key.nvim',
  opts = {
    -- see: https://www.lazyvim.org/plugins/editor#which-keynvim
    -- defaults = {},
    icons = { mappings = false },
    sort = { 'alphanum' },
    spec = {
      mode = { 'n', 'v' }, -- inherited by block of mappings below
      { '<leader><tab>', group = 'Tab' },
      { '<leader>a', group = 'AI' },
      { '<leader>d', group = 'Debug' },
      { '<leader>e', group = 'Editor' },
      { '<leader>f', group = 'File' },
      { '<leader>g', group = 'Git' },
      { '<leader>gl', group = 'Log' },
      { '<leader>gt', group = 'Toggle' },
      { '<leader>i', group = 'Inspect' },
      { '<leader>o', group = 'Open' },
      { '<leader>q', group = 'Quit' },
      { '<leader>r', group = 'Refactor' },
      { '<leader>s', group = 'Search' },
      { '<leader>t', group = 'Test' },
      { '<leader>u', group = 'UI' },
      {
        '<leader>w',
        group = 'Window',
        proxy = '<C-w>', -- add all built-in <C-w> mappings
      },
      { ']', group = 'Next' },
      { '[', group = 'Previous' },
      { 'g', group = 'Go to' },
      { 'gx', desc = 'Open with system app' }, -- improve built-in description
      -- { 'gz', group = 'Surround' },
      { 'z', group = 'fold' },
    },
  },
}
