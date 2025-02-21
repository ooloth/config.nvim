-- TODO: https://www.lazyvim.org/extras/lang/typescript
-- TODO: dap
-- TODO: testing: vitest
-- TODO: testing: jest

local get_system_executable_path = require('config.util').get_system_executable_path

local function prefer_node_modules_executable(executable_name)
  -- get the path to the node_modules binary (if it exists)
  local node_modules_path = vim.fn.getcwd() .. '/node_modules/.bin/' .. executable_name
  if vim.fn.executable(node_modules_path) == 1 then return node_modules_path end

  -- fall back to the systemwide binary
  local system_executable_path = get_system_executable_path(executable_name)
  if vim.fn.executable(system_executable_path) == 1 then return system_executable_path end

  -- fall back to the original executable name
  return executable_name
end

-- TODO: move this to ts_ls settings?
-- see: https://docs.astral.sh/ruff/editors/setup/#neovim
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client == nil then return end
    -- prefer local typescript version (if available)
    if client.name == 'ts_ls' then
      client.config.cmd = { prefer_node_modules_executable('typescript-language-server'), '--stdio' }
    end
  end,
  desc = 'Update TS lsp server command',
})

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
        eslint = {
          -- Automatically fix fixable issues on save:
          -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
          on_attach = function(_, bufnr)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'EslintFixAll',
            })
          end,
          -- see: https://github.com/microsoft/vscode-eslint/tree/main?tab=readme-ov-file#settings-options
          -- defaults: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#eslint
          settings = {
            nodePath = vim.fn.getcwd() .. '/node_modules',
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = 'auto' },
          },
        },
        ts_ls = {
          keys = function() return {} end,
          -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ts_ls
          -- see: https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#tsserver-options
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = false,
              },
            },
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = 'all', -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = false,
              },
            },
          },
        },
      },
      setup = {
        ts_ls = function()
          require('lazyvim.util').lsp.on_attach(function(client, _) -- FIXME: remove lazyvim import?
            -- prefer local typescript version (if available)
            if client.name == 'tsserver' then client.config.cmd = { prefer_node_modules_executable('tsserver'), '--stdio' } end
          end)
        end,
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        -- Also need to install @prettier/plugin-xml in project:
        -- https://github.com/prettier/plugin-xml
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
      },
    },
  },

  -- {
  --   'nvim-neotest/neotest',
  --   dependencies = {
  --     'marilari88/neotest-vitest',
  --     'nvim-neotest/neotest-jest',
  --     'thenbe/neotest-playwright',
  --   },
  --   opts = {
  --     adapters = {
  --       ['neotest-vitest'] = {
  --         -- see: https://github.com/marilari88/neotest-vitest/blob/main/lua/neotest-vitest/init.lua#L7-L11
  --         jestCommand = 'npm test --',
  --         -- jestCommand = require('neotest-jest.jest-util').getJestCommand(vim.fn.expand '%:p:h') .. ' --watch',
  --         jestConfigFile = 'vitest.config.ts',
  --         env = { CI = true },
  --         cwd = function()
  --           return vim.fn.getcwd()
  --         end,
  --       },
  --       ['neotest-jest'] = {
  --         -- see: https://github.com/nvim-neotest/neotest-jest?tab=readme-ov-file#installation
  --         -- args = { '--log-level', 'DEBUG', '--quiet' },
  --         -- dap = {
  --         --   -- see: https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings#launchattach-settings
  --         --   console = 'integratedTerminal',
  --         --   justMyCode = true,
  --         -- },
  --         jestCommand = 'npm test --',
  --         -- jestCommand = require('neotest-jest.jest-util').getJestCommand(vim.fn.expand '%:p:h') .. ' --watch',
  --         jestConfigFile = 'jest.config.ts',
  --         env = { CI = true },
  --         cwd = function()
  --           return vim.fn.getcwd()
  --         end,
  --       },
  --       -- ['neotest-playwright'] = {
  --       --   -- see: https://github.com/thenbe/neotest-playwright?tab=readme-ov-file#configuration
  --       --   options = {
  --       --     persist_project_selection = true,
  --       --     enable_dynamic_test_discovery = true,
  --       --   },
  --       -- },
  --     },
  --   },
  --   -- keys = {
  --   --   {
  --   --     '<leader>tw',
  --   --     "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
  --   --     desc = 'Run Watch',
  --   --   },
  --   -- },
  -- },

  -- {
  --   -- see: https://www.lazyvim.org/extras/lang/typescript#nvim-dap-optional
  --   'mfussenegger/nvim-dap',
  --   dependencies = {
  --     -- Install the vscode-js-debug adapter
  --     -- see: https://github.com/mxsdev/nvim-dap-vscode-js?tab=readme-ov-file#debugger
  --     -- see: https://github.com/nikolovlazar/dotfiles/blob/main/.config/nvim/lua/plugins/dap.lua
  --     {
  --       'microsoft/vscode-js-debug',
  --       -- After install, build it and rename the dist directory to out
  --       build = 'npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out',
  --       version = '1.*',
  --     },
  --     {
  --       'mxsdev/nvim-dap-vscode-js',
  --       opts = {
  --         -- see: https://github.com/mxsdev/nvim-dap-vscode-js?tab=readme-ov-file#setup
  --         -- see: https://github.com/nikolovlazar/dotfiles/blob/main/.config/nvim/lua/plugins/dap.lua
  --         -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  --         -- node_path = "node",
  --
  --         -- Path to vscode-js-debug installation.
  --         debugger_path = vim.fn.resolve(vim.fn.stdpath 'data' .. '/lazy/vscode-js-debug'),
  --
  --         -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
  --         -- debugger_cmd = { 'js-debug-adapter' },
  --
  --         -- which adapters to register in nvim-dap
  --         adapters = {
  --           'chrome',
  --           'pwa-node',
  --           'pwa-chrome',
  --           'pwa-msedge',
  --           'pwa-extensionHost',
  --           'node-terminal',
  --         },
  --
  --         -- Path for file logging
  --         -- log_file_path = "(stdpath cache)/dap_vscode_js.log",
  --
  --         -- Logging level for output to file. Set to false to disable logging.
  --         -- log_file_level = false,
  --
  --         -- Logging level for output to console. Set to false to disable console output.
  --         -- log_console_level = vim.log.levels.ERROR,
  --       },
  --     },
  --   },
  --   opts = function()
  --     local dap = require 'dap'
  --
  --     if not dap.adapters['pwa-node'] then
  --       require('dap').adapters['pwa-node'] = {
  --         type = 'server',
  --         host = 'localhost',
  --         port = '${port}',
  --         executable = {
  --           command = 'node',
  --           -- 💀 Make sure to update this path to point to your installation
  --           args = {
  --             require('mason-registry').get_package('js-debug-adapter'):get_install_path() .. '/js-debug/src/dapDebugServer.js',
  --             '${port}',
  --           },
  --         },
  --       }
  --     end
  --
  --     -- see: https://github.com/nikolovlazar/dotfiles/blob/main/.config/nvim/lua/plugins/dap.lua
  --     -- see: https://www.youtube.com/watch?v=Ul_WPhS2bis
  --     for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
  --       dap.configurations[language] = {
  --         -- for single node files:
  --         {
  --           type = 'pwa-node',
  --           request = 'launch',
  --           name = 'Node: Launch file',
  --           program = '${file}',
  --           cwd = vim.fn.getcwd(),
  --           args = { '--inspect' },
  --           sourceMaps = true,
  --         },
  --         -- for running node processes (make sure to add --inspect when you run the process)
  --         {
  --           type = 'pwa-node',
  --           request = 'attach',
  --           name = 'Node: Attach',
  --           processId = require('dap.utils').pick_process,
  --           cwd = vim.fn.getcwd(),
  --           args = { '--inspect' },
  --           sourceMaps = true,
  --         },
  --         -- for web apps (client side)
  --         {
  --           type = 'pwa-chrome',
  --           request = 'launch',
  --           name = 'Chrome: Launch & Debug',
  --           url = function()
  --             local co = coroutine.running()
  --             return coroutine.create(function()
  --               vim.ui.input({
  --                 prompt = 'Enter port: ',
  --                 default = '3000',
  --               }, function(port)
  --                 if port == nil or port == '' then
  --                   return
  --                 else
  --                   coroutine.resume(co, 'http://localhost:' .. port)
  --                 end
  --               end)
  --             end)
  --           end,
  --           webRoot = vim.fn.getcwd(),
  --           protocol = 'inspector',
  --           sourceMaps = true,
  --           userDataDir = false,
  --           args = { '--inspect' },
  --         },
  --         -- divider before launch.json derived configs
  --         {
  --           name = '↓ launch.json configs ↓',
  --           type = '',
  --           request = 'launch',
  --         },
  --       }
  --     end
  --   end,
  -- },
}
