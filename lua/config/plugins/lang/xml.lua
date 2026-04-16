return {
  -- {
  --   'neovim/nvim-lspconfig',
  --   opts = {
  --     servers = {
  --       -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lemminx
  --       lemminx = {},
  --     },
  --   },
  -- },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- Also need to install @prettier/plugin-xml in project:
        -- https://github.com/prettier/plugin-xml
        xml = { 'prettier' },
      },
    },
  },

  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        -- see: https://www.html-tidy.org (installed via homebrew)
        xml = { 'tidy' },
      },
    },
  },
}
