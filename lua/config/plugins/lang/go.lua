-- TODO: https://www.lazyvim.org/extras/lang/go
-- TODO: Configure Golang in Kickstart.nvim: https://www.youtube.com/watch?v=CNYqPnaCgJw
-- TODO: lsp
-- TODO: linting
-- TODO: dap: 'leoluz/nvim-dap-go'

-- require('dap-go').setup({
--   delve = {
--     -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
--     detached = vim.fn.has('win32') == 0,
--   },
-- })

return {
  -- {
  --   'stevearc/conform.nvim',
  --   opts = {
  --     formatters_by_ft = {
  --       go = { 'gofumpt', 'goimports', 'gci' },
  --     },
  --   },
  -- },
}
