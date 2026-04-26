-- NOTE: prefer debugger over jupyter notebooks
-- TODO: Exploring Data Science Tools and Workflows in NVIM: https://www.youtube.com/watch?v=1xoUmncDwHQ

vim.g.loaded_python3_provider = false

local get_system_executable_path = require('config.util').get_system_executable_path

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
  local uv_venv_default = vim.env.PWD .. '/.venv'
  local uv_venv_roadie = vim.env.PWD .. '/venv'
  local pyenv_venv = (vim.env.PYENV_ROOT or '') .. '/versions/' .. vim.fs.basename(vim.env.PWD)

  return get_first_working_executable({
    (vim.env.VIRTUAL_ENV or '') .. '/bin/' .. executable_name,
    uv_venv_default .. '/bin/' .. executable_name,
    uv_venv_roadie .. '/bin/' .. executable_name,
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
local ruff = prefer_venv_executable('ruff')
local ty = prefer_venv_executable('ty')

-----------------
-- LSP SERVERS --
-----------------

-- ty lsp server (provides type checking)
-- see: https://docs.astral.sh/ty/editors/#neovim
vim.lsp.config('ty', {
  cmd = { ty, 'server' },
  settings = {
    -- see: https://docs.astral.sh/ty/reference/editor-settings/
    logLevel = 'warn',
  },
})
vim.lsp.enable('ty')

-- ruff lsp server (provides linting and formatting)
-- see: https://docs.astral.sh/ruff/editors/setup/#neovim
vim.lsp.config('ruff', {
  cmd = { ruff, 'server' },
  settings = {
    -- see: https://docs.astral.sh/ruff/editors/settings/
    configurationPreference = 'filesystemFirst',
    logLevel = 'warn',
  },
})
vim.lsp.enable('ruff')

-- see: https://docs.astral.sh/ruff/editors/setup/#neovim
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP: Disable ruff server hover capability',
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client == nil then return end
    if client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false -- Disable hover in favor of ty
    end
  end,
})

-- see: https://github.com/astral-sh/ruff/issues/12514
-- see: https://github.com/astral-sh/ruff/discussions/12308
vim.api.nvim_create_autocmd('BufWritePost', {
  desc = 'LSP: Sort imports on save using ruff server code action',
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
        -- Save after sorting to dismiss ruff warning a couple seconds sooner
        -- Delay the write operation 100ms to ensure the code action is applied first
        vim.defer_fn(function() vim.cmd('update') end, 100)
        break
      end
    end
  end,
})

return {
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

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'mfussenegger/nvim-dap-python',
      keys = {
        -- { '<leader>dPt', function() require('dap-python').test_method() end, desc = 'Debug Method', ft = 'python' },
        -- { '<leader>dPc', function() require('dap-python').test_class() end, desc = 'Debug Class', ft = 'python' },
      },
      config = function()
        local dap_python = require('dap-python')

        -- NOTE: Ideally, I prefer to use the "uv" option since it doesn't require every project to install debugpy and allows me
        -- to expect a consistent debugpy version in every project. But it immediately exits with an error on my work laptop...
        -- uv will provide its own debugpy executable (ignoring the one in venv, if present)
        -- see: https://github.com/mfussenegger/nvim-dap-python/blob/master/lua/dap-python.lua#L242-L243
        local python_path = vim.env.IS_WORK == 'true' and python or 'uv'

        dap_python.test_runner = 'pytest'
        dap_python.setup(python_path, { include_configs = false })
      end,
    },
  },

  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/neotest-python',
    },
    opts = function()
      return {
        adapters = {
          require('neotest-python')({
            -- see: https://docs.pytest.org/en/stable/how-to/output.html
            args = { '--quiet', '--showlocals', '-vv' },
            dap = {
              -- see: https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings#launchattach-settings
              console = 'integratedTerminal',
            },
            python = python,
          }),
        },
      }
    end,
  },
}
