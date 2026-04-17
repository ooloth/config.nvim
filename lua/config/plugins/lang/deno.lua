-- From the denols docs
vim.g.markdown_fenced_languages = {
  'ts=typescript',
}

-- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#denols
-- see: https://docs.deno.com/runtime/getting_started/setup_your_environment/#neovim-0.6%2B-using-the-built-in-language-server
-- FIXME: only if there's a deno.json? (TODO: unblock when I can get it to only apply to deno projects)
vim.lsp.config('denols', {
  root_markers = { 'deno.json', 'deno.jsonc', 'deno.lock' },
  settings = {
    deno = {
      enable = true,
      -- enable = is_deno_project(),
      suggest = {
        imports = {
          hosts = {
            ['https://deno.land'] = true,
          },
        },
      },
    },
  },
})
vim.lsp.enable('denols')

return {}
