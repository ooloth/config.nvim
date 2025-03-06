return {
  'SmiteshP/nvim-navic',
  lazy = true,
  opts = {},
  init = function()
    vim.g.navic_silence = true

    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP: Enable Navic',
      group = vim.api.nvim_create_augroup('lsp_attach_enable_navic', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client == nil then return end
        if client.supports_method('textDocument/documentSymbol') then require('nvim-navic').attach(client, event.buf) end
      end,
    })
  end,
}
