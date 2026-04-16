return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#astro
        astro = {},
      },
    },
  },

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
