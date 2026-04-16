vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach_enable_yamlls_formatting', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client == nil then return end
    if client.name == 'yamlls' then client.server_capabilities.documentFormattingProvider = true end
  end,
  desc = 'LSP: Enable formatting capability from Yaml LS',
})

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'b0o/schemastore.nvim',
    },
    opts = function(_, opts) -- using function syntax to support lazy loading schemastore below
      opts.servers.yamlls = {
        settings = {
          redhat = {
            telemetry = { enabled = false },
          },
          yaml = {
            -- https://github.com/redhat-developer/yaml-language-server?tab=readme-ov-file#language-server-settings
            -- editor = {
            --   tabSize = 2,
            -- },
            -- format = {
            --   enable = true, -- yaml language server handles formatting
            -- },
            keyOrdering = false,
            schemas = require('schemastore').yaml.schemas(), -- and linting
            schemaStore = {
              -- see: https://github.com/b0o/SchemaStore.nvim?tab=readme-ov-file#usage
              enable = false, -- must disable built-in schemaStore support to use schemas from SchemaStore.nvim plugin
              url = '', -- avoid TypeError: Cannot read properties of undefined (reading 'length')
            },
            validate = true,
          },
        },
      }
      return opts
    end,
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        yaml = { 'prettier' },
      },
    },
  },
}
