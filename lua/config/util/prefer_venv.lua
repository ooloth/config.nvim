local get_system_executable_path = require('config.util').get_system_executable_path

local M = {}

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
M.get_venv_executable_path = function(executable_name)
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
M.is_installed_in_venv = function(executable_name) return M.get_venv_executable_path(executable_name) ~= '' end

-- see: https://github.com/fredrikaverpil/dotfiles/blob/main/nvim-lazyvim/lua/plugins/lsp.lua
M.prefer_venv_executable = function(executable_name)
  -- get the path to the virtualenv binary (if it exists)
  local venv_executable_path = M.get_venv_executable_path(executable_name)
  if venv_executable_path ~= '' then return venv_executable_path end

  -- otherwise, get the path to python outside a virtualenv from pyenv
  if executable_name == 'python' then
    -- return output of `pyenv which python` if it exists
    if vim.fn.executable('pyenv') == 1 then return string.gsub(vim.fn.system('pyenv which python'), '\n', '') end
    -- otherwise, return the output of `which python3` if it exists
    return vim.fn.exepath('python3')
  end

  -- fall back to the systemwide binary
  local system_executable_path = get_system_executable_path(executable_name)
  if vim.fn.executable(system_executable_path) == 1 then return system_executable_path end

  -- fall back to the original executable name
  return executable_name
end

return M
