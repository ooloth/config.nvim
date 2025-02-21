-- From the denols docs
vim.g.markdown_fenced_languages = {
  'ts=typescript',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'javascript', 'jsdoc', 'typescript', 'tsx' },
    },
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#denols
        denols = {
          root_dir = function() require('lspconfig.util').root_pattern('deno.json', 'deno.jsonc', 'deno.lock') end,
          settings = {
            deno = {
              -- FIXME: only if there's a deno.json?
              -- see: https://docs.deno.com/runtime/getting_started/setup_your_environment/#neovim-0.6%2B-using-the-built-in-language-server
              enable = true, -- TODO: unblock when I can get it to only apply to deno projects
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
          setup = {
            deno_ls = function()
              local nvim_lsp = require('nvim_lsp')
              nvim_lsp.deno_ls.setup({
                root_dir = nvim_lsp.util.root_pattern('deno.json', 'deno.lock'),
              })
              -- require('lazyvim.util').lsp.on_attach(function(client, _) -- FIXME: remove lazyvim import?
              --   if client.name == 'deno_ls' then
              --     client.config.enabled = is_deno_project()
              --   end
              -- end)
            end,
          },
        },
      },
    },
  },
}
