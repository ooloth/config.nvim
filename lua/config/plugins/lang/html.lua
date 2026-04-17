-- TODO: linting: https://htmlhint.com/docs/user-guide/getting-started

-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#html
vim.lsp.enable('html')

return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        html = { 'prettier' },
      },
    },
  },

  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        -- see: https://www.html-tidy.org (installed via homebrew)
        html = { 'tidy' },
      },
    },
  },
}
