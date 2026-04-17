local check_external_reqs = function()
  for _, exe in ipairs({ 'git', 'make', 'unzip', 'rg' }) do
    local is_executable = vim.fn.executable(exe) == 1
    if is_executable then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end
end

-- Reads all lang/*.lua files and collects server names from vim.lsp.enable('...') calls.
-- This stays in sync with lang files automatically — no hardcoded list.
local function discover_enabled_servers()
  local servers = {}
  -- Derive path relative to this file so it works regardless of NVIM_APPNAME / symlinks
  local this_file = debug.getinfo(1, 'S').source:sub(2)
  local config_root = this_file:match('^(.+)/lua/config/util/health%.lua$')
  local lang_dir = config_root .. '/lua/config/plugins/lang'
  local files = vim.fn.glob(lang_dir .. '/*.lua', false, true)
  for _, file in ipairs(files) do
    for _, line in ipairs(vim.fn.readfile(file)) do
      if not line:match('^%s*%-%-') then
        local name = line:match("vim%.lsp%.enable%('([^']+)'%)")
        if name then table.insert(servers, name) end
      end
    end
  end
  table.sort(servers)
  return servers
end

local check_lsp = function()
  vim.health.start('LSP servers')

  local ok = pcall(require, 'schemastore')
  if ok then
    vim.health.ok('schemastore.nvim is loadable')
  else
    vim.health.error('schemastore.nvim not loadable — json/yaml schemas will be missing')
  end

  for _, name in ipairs(discover_enabled_servers()) do
    local cfg = vim.lsp.config[name]
    local exe = cfg and cfg.cmd and cfg.cmd[1]
    if not exe then
      vim.health.warn(name .. ': no cmd defined (may use a custom launcher)')
    elseif vim.fn.executable(exe) == 1 then
      vim.health.ok(string.format("Found executable: '%s' (%s)", exe, name))
    else
      vim.health.warn(string.format("Could not find executable: '%s' (%s)", exe, name))
    end
  end
end

return {
  check = function()
    vim.health.start('config.nvim')

    vim.health.info([[
      NOTE: Not every warning is a 'must-fix' in `:checkhealth`. Fix only warnings for plugins and languages you intend to use.
    ]])

    check_external_reqs()
    check_lsp()
  end,
}
