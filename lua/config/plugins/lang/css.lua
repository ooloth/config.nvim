--  TODO: linting?

vim.lsp.enable('cssls')
vim.lsp.enable('css_variables')
vim.lsp.enable('tailwindcss')

return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        css = { 'prettier' },
        less = { 'prettier' },
        scss = { 'prettier' },
      },
    },
  },
}
