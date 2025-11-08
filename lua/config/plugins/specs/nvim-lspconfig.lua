---@module 'nvim-lspconfig'

-- TODO: gd: go straight to definition?
-- TODO: inlay hints: configure to show only some (e.g. show arg types but hide function reference counts?)
-- TODO: more ideas: https://github.com/ilias777/nvim/blob/1d0f2e122525869025c4fd6171d69a23020234e1/lua/plugins/lsp/lsp-config.lua

-- DOCS: https://www.lazyvim.org/plugins/lsp

local diagnostic_signs_by_severity = {
  [vim.diagnostic.severity.ERROR] = ' ',
  [vim.diagnostic.severity.WARN] = ' ',
  [vim.diagnostic.severity.INFO] = ' ',
  [vim.diagnostic.severity.HINT] = ' ',
}

-- see: `:h vim.diagnostic.Opts`
-- see: https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts
vim.diagnostic.config({
  float = {
    -- NOTE: border padding configured via noice.nvim.opts.lsp.hover.opts.border to take advantage of nui.nvim's ability to customize padding
    border = 'rounded',
    source = true,
  },
  severity_sort = true,
  signs = diagnostic_signs_by_severity,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = 'if_many',
    prefix = function(diagnostic) return diagnostic_signs_by_severity[diagnostic.severity] end,
  },
})

local set_lsp_keymaps = function(lsp_attach_event)
  ---@param mode string|string[]
  ---@param lhs string
  ---@param rhs string|function
  ---@param desc string
  ---@param opts vim.keymap.set.Opts?
  local buffer_map = function(mode, lhs, rhs, desc, opts)
    ---@type vim.keymap.set.Opts
    local options = opts or {}
    options.buffer = lsp_attach_event.buf
    options.desc = desc

    vim.keymap.set(mode or 'n', lhs, rhs, options)
  end

  buffer_map('n', 'gh', function() require('noice.lsp').hover() end, 'Show hover doc')
  buffer_map({ 'n', 'x' }, '<leader>ra', vim.lsp.buf.code_action, 'Code action') -- execute a code action, usually your cursor needs to be on top of an error or a suggestion from your LSP for this to activate
  buffer_map('n', '<leader>rr', vim.lsp.buf.rename, 'Rename symbol under cursor', { expr = true })

  local client = vim.lsp.get_client_by_id(lsp_attach_event.data.client_id)

  -- Set keymap to toggle inlay hints if the language server supports them
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, lsp_attach_event.buf) then
    buffer_map(
      'n',
      '<leader>ui',
      function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = lsp_attach_event.buf })) end,
      'Inlay hints (toggle)'
    )
  end
end

local highlight_references_to_cursor_word_in_editor = function(lsp_attach_event)
  local client = vim.lsp.get_client_by_id(lsp_attach_event.data.client_id)

  -- Highlight references to word under cursor
  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = lsp_attach_event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    -- Clear highlights when cursor moves
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = lsp_attach_event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    -- Clear highlights when lsp detaches
    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = event2.buf })
      end,
    })
  end
end

local show_active_diagnostics_on_cursor_line = function()
  -- see: https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
  vim.api.nvim_create_autocmd('CursorHold', {
    callback = function() vim.diagnostic.open_float(nil, { focusable = false }) end,
  })
end

-- NOTE: requires configuring each LSP server to provide the inlay hints
local enable_inlay_hints = function(lsp_attach_event)
  -- see: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua#L146-L157
  if vim.api.nvim_buf_is_valid(lsp_attach_event.buf) and vim.bo[lsp_attach_event.buf].buftype == '' then
    vim.lsp.inlay_hint.enable(true, { bufnr = lsp_attach_event.buf })
  end
end

-- NOTE: requires configuring each LSP server to provide the code lenses
local enable_code_lenses = function(lsp_attach_event)
  -- see: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/init.lua#L159-L168
  if vim.lsp.codelens then
    vim.lsp.codelens.refresh()
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      buffer = lsp_attach_event.buf,
      callback = vim.lsp.codelens.refresh,
    })
  end
end

return {
  'neovim/nvim-lspconfig',
  event = { 'BufNewFile', 'BufRead', 'BufWritePre' },
  dependencies = {
    'folke/noice.nvim', -- for 'gh' keymap
    'hrsh7th/cmp-nvim-lsp', -- extend nvim's default lsp capabilities
    'j-hui/fidget.nvim', -- show lsp updates via discrete UI in the bottom right
    'stevearc/dressing.nvim', -- keymaps: better vim.ui.select UI (e.g. for code actions)
  },
  config = function(_, opts)
    -- Enable behavior that should exist while any LSP is attached
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        set_lsp_keymaps(event)
        highlight_references_to_cursor_word_in_editor(event)
        -- show_active_diagnostics_on_cursor_line() -- NOTE: let's see if I miss this
        -- enable_inlay_hints(event) -- NOTE: toggle on with leader-ui, but don't turn on by default
        enable_code_lenses(event)
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Avoid an nvim-ufo error in the yaml-language-server
    -- see: https://github.com/redhat-developer/yaml-language-server/issues/912#issuecomment-1797097638
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    -- Set up all servers configured via nvim-lspconfig's "opts.servers" table in each lang/* file
    for server_name, server_options in pairs(opts.servers) do
      -- Merge neovim's LSP capabilities + nvim-cmp's capabilities + any overrides I've defined for this server
      server_options.capabilities = vim.tbl_deep_extend(
        'force',
        capabilities,
        require('cmp_nvim_lsp').default_capabilities(),
        server_options.capabilities or {}
      )

      -- Set up server
      require('lspconfig')[server_name].setup(server_options)
    end

    -- Call all server setup functions configured via nvim-lspconfig's "opts.setup" table in each lang/* file
    for _, server_setup in pairs(opts.setup) do
      server_setup()
    end
  end,
}
