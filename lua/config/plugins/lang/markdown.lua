-- TODO: https://www.lazyvim.org/extras/lang/markdown

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman
vim.lsp.enable('marksman')
-- FIXME: mdx_analyzer getting TS-related errors; enable when fixed
-- vim.lsp.enable('mdx_analyzer') -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#mdx_analyzer

return {
  {
    'davidmh/mdx.nvim',
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
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    -- dependencies = { 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    ft = { 'markdown', 'codecompanion' }, -- see: https://codecompanion.olimorris.dev/configuration/chat-buffer.html#markdown-rendering
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      latex = { enabled = false },
    },
  },
}
