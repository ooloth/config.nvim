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
    'davidmh/mdx.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        marksman = {}, -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman
        -- FIXME: getting TS-related errors:
        -- mdx_analyzer = {
        --   init_options = {}, -- TODO: enable TS support only if typescript installed in workspace
        -- }, -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#mdx_analyzer
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        markdown = { 'prettier' },
        mdx = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
      },
    },
  },

  -- Better markdown rendering in normal mode
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    ft = { 'markdown', 'codecompanion' }, -- see: https://codecompanion.olimorris.dev/configuration/chat-buffer.html#markdown-rendering
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      latex = { enabled = false },
    },
  },
}
