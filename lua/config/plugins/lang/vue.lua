-- TODO: https://www.lazyvim.org/extras/lang/vue

-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vuels
vim.lsp.enable('vuels')

return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        vue = { 'prettier' },
      },
    },
  },
}
