-- TODO: https://www.lazyvim.org/extras/lang/markdown

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'markdown', 'markdown_inline', 'mermaid' },
    },
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman
        marksman = {},
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        markdown = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
      },
    },
  },

  -- Prettier markdown rendering in normal mode
  require('config.plugins.specs.render-markdown'),
}
