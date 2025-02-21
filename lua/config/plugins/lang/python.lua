-- TODO: Exploring Data Science Tools and Workflows in NVIM: https://www.youtube.com/watch?v=1xoUmncDwHQ
-- TODO: testing: unittest?
-- TODO: https://www.lazyvim.org/extras/lang/python

local get_system_executable_path = require('config.util').get_system_executable_path

-- see: https://docs.astral.sh/ruff/editors/setup/#neovim
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client == nil then return end
    if client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false -- Disable hover in favor of Pyright
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

-- Organize imports with the ruff language server if it's active
-- see: https://github.com/astral-sh/ruff/issues/12514
-- see: https://github.com/astral-sh/ruff/discussions/12308
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = { '*.py' },
  callback = function(event)
    for _, client in pairs(vim.lsp.get_clients({ bufnr = event.buf })) do
      if client.name == 'ruff' then
        vim.lsp.buf.code_action({
          context = {
            only = { 'source.organizeImports' },
            diagnostics = {},
          },
          apply = true,
        })
        -- Delay the write operation to ensure the code action is applied first
        vim.defer_fn(function() vim.cmd('update') end, 100) -- 100 milliseconds delay
        break
      end
    end
  end,
})

---@param paths table A list of paths to check for executables
---@return string The first callable in the list of paths
local function get_first_working_executable(paths)
  for _, path in ipairs(paths) do
    if vim.fn.executable(path) == 1 then return path end
  end
  return ''
end

---Get the path to the executable in the current virtual environment.
---@param executable_name string: The name of the executable to find
---@return string: The path to the executable in the current virtual environment
local function get_venv_executable_path(executable_name)
  local uv_venv = vim.env.PWD .. '/.venv'
  local pyenv_venv = (vim.env.PYENV_ROOT or '') .. '/versions/' .. vim.fs.basename(vim.env.PWD)

  return get_first_working_executable({
    (vim.env.VIRTUAL_ENV or '') .. '/bin/' .. executable_name,
    uv_venv .. '/bin/' .. executable_name,
    pyenv_venv .. '/bin/' .. executable_name,
  })
end

---Check if an executable is installed in the current virtual environment.
---@param executable_name string: The name of the executable to check
---@return boolean: Whether the executable is installed in the current virtual environment
local function is_installed_in_venv(executable_name) return get_venv_executable_path(executable_name) ~= '' end

-- see: https://github.com/fredrikaverpil/dotfiles/blob/main/nvim-lazyvim/lua/plugins/lsp.lua
local function prefer_venv_executable(executable_name)
  -- get the path to the virtualenv binary (if it exists)
  local venv_executable_path = get_venv_executable_path(executable_name)
  if venv_executable_path ~= '' then return venv_executable_path end

  -- otherwise, return the output of `which python3` if it exists
  if executable_name == 'python' then return vim.fn.exepath('python3') end

  -- fall back to the systemwide binary
  local system_executable_path = get_system_executable_path(executable_name)
  if vim.fn.executable(system_executable_path) == 1 then return system_executable_path end

  -- fall back to the original executable name
  return executable_name
end

---Returns a list of formatters that are installed in the venv. If ruff is installed in the venv, returns an empty list so the ruff server can handle formatting.
---@param formatters string[]
---@return string[]
local get_formatters_in_venv = function(formatters)
  if is_installed_in_venv('ruff') then return {} end
  return vim.tbl_filter(function(formatter) return is_installed_in_venv(formatter) end, formatters)
end

---Return a list of linters that are installed in the venv. If ruff is installed in the venv, removes flake8 so the ruff server can handle linting.
---Does not remove all linters so mypy can still be used for type checking.
---@param linters string[]
---@return string[]
local get_linters_in_venv = function(linters)
  local linters_in_venv = vim.tbl_filter(function(linter) return is_installed_in_venv(linter) end, linters)
  if is_installed_in_venv('ruff') then
    return vim.tbl_filter(function(linter) return linter ~= 'flake8' end, linters_in_venv)
  end
  return linters_in_venv
end

---Updates a formatter's command to use the venv installation if found. If ruff is installed in the venv, ensures other formatters are disabled.
---@param formatter string
---@return table
local get_formatter_options = function(formatter)
  local formatter_options = require('conform.formatters.' .. formatter)
  formatter_options.command = prefer_venv_executable(formatter)
  formatter_options.condition = function() return is_installed_in_venv(formatter) end
  return formatter_options
end

local get_linter_options = function(linter)
  local linter_options = require('lint.linters.' .. linter)
  linter_options.cmd = prefer_venv_executable(linter)
  return linter_options
end

-- get the python executable from the project venv (if active) for pyright, dap and neotest
local python = prefer_venv_executable('python')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = {
      ensure_installed = { 'python', 'requirements' },
    },
  },

  {
    'neovim/nvim-lspconfig',
    -- see: https://www.lazyvim.org/extras/lang/python#nvim-lspconfig
    opts = {
      servers = {
        -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
        pyright = {
          capabilities = (function()
            -- Disable Pyright diagnostics (use flake8 or ruff for linting):
            -- see: https://www.reddit.com/r/neovim/comments/11k5but/how_to_disable_pyright_diagnostics/
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
            return capabilities
          end)(),
          settings = {
            -- see: https://microsoft.github.io/pyright/#/settings
            pyright = {
              disableOrganizeImports = true, -- use ruff for import sorting
            },
            python = {
              analysis = {
                ignore = { '*' }, -- use ruff for linting
                typeCheckingMode = 'off', -- use mypy for type checking
              },
              pythonPath = python, -- point pyright to venv
            },
          },
        },
        -- Ruff Server (replaces ruff_lsp and handles linting, formatting and code actions)
        -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff
        -- see: https://docs.astral.sh/ruff/editors/setup/#neovim
        ruff = {
          cmd = { prefer_venv_executable('ruff'), 'server', '--preview' },
          init_options = {
            settings = {
              -- see: https://docs.astral.sh/ruff/editors/settings/
              configurationPreference = 'filesystemFirst',
              logLevel = 'warn',
            },
          },
        },
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        python = get_formatters_in_venv({ 'black', 'isort', 'yapf' }), -- defaults to ruff language server if present
      },
      formatters = {
        black = get_formatter_options('black'),
        isort = get_formatter_options('isort'),
        yapf = get_formatter_options('yapf'),
      },
    },
  },

  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        python = get_linters_in_venv({ 'flake8', 'mypy' }), -- defaults to ruff language server if present
      },
      linters = {
        flake8 = get_linter_options('flake8'),
        mypy = get_linter_options('mypy'),
      },
    },
  },

  -- TODO: dap
  -- {
  --   'mfussenegger/nvim-dap',
  --   dependencies = {
  --     'mfussenegger/nvim-dap-python',
  --     keys = {
  --       { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
  --       { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
  --     },
  --     config = function()
  --       -- TODO: nope. trying not to have that venv. is there an alternative? otherwise I can just install it in any project complex enough to require debugging.
  --       -- use the debugpy installed in the pynvim venv so I don't have to install it in every project's venv:
  --       local pynvim_debugpy_python = vim.env.HOME .. '/.pyenv/versions/pynvim/bin/debugpy' .. '/venv/bin/python'
  --
  --       require('dap-python').setup(pynvim_debugpy_python, { include_configs = true, pythonPath = python })
  --     end,
  --   },
  -- },

  -- TODO: testing
  -- {
  --   'nvim-neotest/neotest',
  --   dependencies = {
  --     'nvim-neotest/neotest-python',
  --   },
  --   opts = {
  --     adapters = {
  --       ['neotest-python'] = {
  --         -- see: https://github.com/nvim-neotest/neotest-python
  --         args = { '--log-level', 'DEBUG', '--quiet' },
  --         dap = {
  --           -- see: https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings#launchattach-settings
  --           console = 'integratedTerminal',
  --           justMyCode = true,
  --         },
  --         python = python,
  --       },
  --     },
  --   },
  -- },
}
