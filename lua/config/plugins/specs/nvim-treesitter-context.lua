-- Show sticky nested hierarchy at top of screen as you scroll

return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    max_lines = 8,
  },
}
