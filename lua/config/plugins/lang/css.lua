--  TODO: linting?

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        cssls = {},
        css_variables = {},
        -- cssmodules_ls = {},
        tailwindcss = {},
      },
      setup = {
        -- tailwindcss = function(_, opts)
        --   local default_filetypes_to_remove = { 'markdown' }
        --
        --   -- Remove markdown from tailwindcss filetypes
        --   opts.filetypes = vim.tbl_filter(
        --     function(ft) return not vim.tbl_contains(default_filetypes_to_remove, ft) end,
        --     require('lspconfig.configs.tailwindcss').default_config.filetypes
        --   )
        -- end,
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        css = { 'prettier' },
        less = { 'prettier' },
        scss = { 'prettier' },
      },
    },
  },
}
