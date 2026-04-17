-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#astro
-- astro-ls requires the TypeScript SDK path to function; falls back gracefully if not in project
vim.lsp.config('astro', {
  init_options = {
    typescript = {
      tsdk = vim.fn.getcwd() .. '/node_modules/typescript/lib',
    },
  },
})
vim.lsp.enable('astro')

return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- Also need to install prettier-plugin-astro in project
        -- see: https://github.com/withastro/prettier-plugin-astro#installation
        astro = { 'prettier' },
      },
    },
  },
}
