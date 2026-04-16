return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        protobuf = { 'buf' },
      },
    },
  },

  {
    -- see: https://github.com/mfussenegger/nvim-lint
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        -- see: https://github.com/bufbuild/buf
        protobuf = { 'buf_lint' },
      },
    },
  },
}
