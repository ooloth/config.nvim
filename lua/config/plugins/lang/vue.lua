-- TODO: https://www.lazyvim.org/extras/lang/vue

-- vue_ls (Volar v2) requires ts_ls to attach alongside it on .vue files.
-- This extends ts_ls to handle vue filetypes and loads @vue/typescript-plugin.
-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vue_ls
local function vue_ts_plugin_location()
  local path = vim.fn.getcwd() .. '/node_modules/@vue/typescript-plugin'
  if vim.fn.isdirectory(path) == 1 then return path end
  return ''
end

vim.lsp.config('ts_ls', {
  -- must include the full default filetypes list since arrays replace rather than merge
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue' },
  init_options = {
    plugins = {
      { name = '@vue/typescript-plugin', location = vue_ts_plugin_location(), languages = { 'vue' } },
    },
  },
})
vim.lsp.enable('vue_ls')

return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        vue = { 'prettier' },
      },
    },
  },
}
