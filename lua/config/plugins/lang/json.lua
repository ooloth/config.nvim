-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jsonls
-- see: https://github.com/b0o/SchemaStore.nvim?tab=readme-ov-file#usage
-- FIXME: why does tsconfig.json not seem to receive validations? (yaml working fine)
-- vim.schedule defers until after lazy.nvim loads plugins, so schemastore is available
vim.schedule(function()
  vim.lsp.config('jsonls', {
    settings = {
      json = {
        format = { enable = true },
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  })
end)
vim.lsp.enable('jsonls')

return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        json = { 'prettier' },
        jsonc = { 'prettier' },
      },
    },
  },
}
