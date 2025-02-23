-- TODO: https://www.lazyvim.org/extras/lang/json
-- TODO: nvim-lint: consider the default linter: json = { "jsonlint" } (is schemastore enough?)

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'jq', 'json', 'json5', 'jsonc' },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'b0o/schemastore.nvim',
    },
    opts = function(_, opts)
      opts.servers.jsonls = {
        -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#jsonls
        settings = {
          json = {
            format = {
              -- FIXME: how to avoid formatting vscode settings? skip comments available? ignore file available? need to disable this?
              enable = true,
            },
            -- see: https://github.com/b0o/SchemaStore.nvim?tab=readme-ov-file#usage
            -- FIXME: why does tsconfig.json not seem to receive validations? (yaml working fine)
            schemas = require('schemastore').json.schemas(),
            validate = {
              enable = true,
            },
          },
        },
      }
    end,
  },

  -- {
  --   'stevearc/conform.nvim',
  --   opts = {
  --     formatters_by_ft = {
  --       json = { 'prettier' },
  --       jsonc = { 'prettier' },
  --     },
  --   },
  --   },
}
