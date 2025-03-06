-- Show sticky nested hierarchy at top of screen as you scroll

-- DOCS: https://github.com/nvim-treesitter/nvim-treesitter-context
-- DOCS: https://www.lazyvim.org/extras/ui/treesitter-context

return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  -- dependencies = {
  -- 'nvim-treesitter/nvim-treesitter',
  -- },
  opts = {
    mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- on_attach = function()
    -- vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#1e1e2e', underline = false })
    -- end,
  },
  -- init = function()
  --   vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#1e1e2e', underline = false })
  -- end,
}
