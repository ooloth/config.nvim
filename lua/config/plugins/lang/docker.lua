-- TODO: linting?
-- TODO: nvim-lint: consider the default linter: dockerfile = { "hadolint" },
-- TODO: https://www.lazyvim.org/extras/lang/docker

-- Requires https://github.com/rcjsuen/dockerfile-language-server-nodejs
-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#dockerls
vim.lsp.enable('dockerls')

return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- No CLI formatters, so conform formats with dockerls. The entry has to exist so the '_'
        -- catch-all in conform.lua doesn't claim dockerfile.
        dockerfile = { lsp_format = 'fallback' },
      },
    },
  },
}
