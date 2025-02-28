-- TODO: linting
-- TODO: debugging: https://www.lazyvim.org/extras/dap/nlua

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'lua', 'luadoc', 'luap' },
    },
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              -- see: https://github.com/luals/lua-language-server/blob/master/locale/en-us/setting.lua
              -- see: https://luals.github.io/wiki/settings/
              codeLens = {
                enable = false, -- "N references" after functions kept flickering on save
              },
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                disable = { 'missing-fields' }, -- don't complain about partial config overrides (so I can add their types)
              },
              doc = {
                privateName = { '^_' },
              },
              hint = {
                arrayIndex = 'Disable',
                enable = true,
                paramType = true, -- requires the parameters to be defined with @param
                paramName = 'Disable', -- 'All', 'Literal', 'Disable'
                semicolon = 'Disable',
                setType = true, -- display the type being applied at assignment operations
              },
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
      },
    },
  },

  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    -- see: https://github.com/folke/lazydev.nvim
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        'lazy.nvim',
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = { lua = { 'stylua' } },
    },
  },

  -- {
  --   -- see: https://github.com/mfussenegger/nvim-lint
  --   'mfussenegger/nvim-lint',
  --   opts = {
  --     -- see: https://www.lazyvim.org/plugins/linting#nvim-lint
  --     -- see: https://github.com/mfussenegger/nvim-lint#available-linters
  --     linters_by_ft = {
  --       lua = { 'luacheck' },
  --     },
  --   },
  -- },
}
