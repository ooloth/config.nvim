local M = {}

---Extends a list-type table with another list-type table only (not a dictionary).
---@type fun(list:table, values:table): table
M.extend = function(list, items) vim.list_extend(list or {}, items) end

M.get_system_executable_path = function(executable_name)
  if vim.fn.executable('/usr/bin/' .. executable_name) == 1 then return executable_name end
  if vim.fn.executable('/usr/local/bin/' .. executable_name) == 1 then return '/usr/local/bin/' .. executable_name end
  if vim.fn.executable('/usr/local/opt/' .. executable_name) == 1 then return '/usr/local/opt/' .. executable_name end
  if vim.fn.executable('/opt/homebrew/bin/' .. executable_name) == 1 then return '/opt/homebrew/bin/' .. executable_name end

  return ''
end

-----------------------------------------------------------
-- Returns table combining all lazy configs in the given directory
-- Useful for automatically loading new language configs added to plugins/lang
-- @param dir_rel_path: relative path to config subdirectory after 'lua/config'
-----------------------------------------------------------
M.require_all_files_in_config_directory = function(dir_rel_path)
  local config_abs_path = vim.env.HOME .. '/Repos/ooloth/config.nvim/lua/config/'
  local directory_abs_path = config_abs_path .. dir_rel_path
  local all_plugin_configs_in_directory = {}

  for _, file in ipairs(vim.fn.readdir(directory_abs_path)) do
    local file_without_extension = file:gsub('%.lua$', '')
    local dir_rel_require_path = dir_rel_path:gsub('/', '.')
    local require_path = 'config.' .. dir_rel_require_path .. '.' .. file_without_extension
    table.insert(all_plugin_configs_in_directory, require(require_path))
  end

  return all_plugin_configs_in_directory
end

return M
