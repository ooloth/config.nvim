-- TODO: https://www.lazyvim.org/extras/lang/sql
-- TODO: formatting?
-- TODO: linting?

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'sql' },
    },
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        sqlls = {}, -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#sqlls
      },
      setup = {},
    },
  },
}
