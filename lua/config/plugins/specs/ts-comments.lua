-- See: https://github.com/folke/ts-comments
-- Supports JSX/TSX comments

return {
  'folke/ts-comments.nvim',
  opts = {},
  event = 'VeryLazy',
  enabled = vim.fn.has('nvim-0.10.0') == 1,
}
