-- TODO: linting?

vim.lsp.enable('taplo')

return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- No CLI formatters, so conform formats with taplo's language server. The entry has to exist so
        -- the '_' catch-all in conform.lua doesn't claim toml. The LSP finds the project's .taplo.toml
        -- from the file; conform's taplo CLI formatter would look from nvim's working directory instead.
        toml = { lsp_format = 'fallback' },
      },
    },
  },
}
