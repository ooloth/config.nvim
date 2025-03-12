---@module 'mini.statusline'

-- TODO: cache values that are expensive to compute each time cursor moves?

local get_file_path = function()
  local rel_path = vim.fn.expand('%:~:.')
  local width = vim.api.nvim_win_get_width(0)

  -- In terminal always use plain name
  local file_path = vim.bo.buftype == 'terminal' and '%t'
    or rel_path == '' and '[No Name]'
    or width < 125 and vim.fn.pathshorten(rel_path, 1)
    or width < 130 and vim.fn.pathshorten(rel_path, 2)
    or width < 135 and vim.fn.pathshorten(rel_path, 3)
    or width < 140 and vim.fn.pathshorten(rel_path, 4)
    or width < 145 and vim.fn.pathshorten(rel_path, 5)
    or width < 150 and vim.fn.pathshorten(rel_path, 6)
    or width < 155 and vim.fn.pathshorten(rel_path, 7)
    or width < 160 and vim.fn.pathshorten(rel_path, 8)
    or rel_path

  if vim.bo.readonly then file_path = file_path .. ' [RO]' end

  return file_path
end

local macro_recording_in_progress = function()
  if vim.fn.reg_recording() ~= '' then
    return 'Recording @' .. vim.fn.reg_recording()
  else
    return ''
  end
end

local get_attached_tools = function()
  local lsp_servers_attached_to_this_buffer = vim.lsp.get_clients({ bufnr = vim.fn.bufnr('%') })
  local linters_configured_for_this_filetype = require('lint').linters_by_ft[vim.bo.filetype] or {}
  local formatters_configured_for_this_filetype = require('conform').list_formatters_for_buffer(vim.fn.bufnr('%')) or {}

  -- Use a table's keys to track unique tool names (to prevent duplicates from accumulating)
  local unique_tool_names = {}

  -- Add LSP clients to the unique tool names
  for _, lsp_client in ipairs(lsp_servers_attached_to_this_buffer) do
    unique_tool_names[lsp_client.name] = true
  end

  -- Add linters to the unique tool names
  for _, linter in ipairs(linters_configured_for_this_filetype) do
    unique_tool_names[linter] = true
  end

  -- Add formatters to the unique tool names
  for _, formatter in ipairs(formatters_configured_for_this_filetype) do
    unique_tool_names[formatter] = true
  end

  -- Convert the keys of the table back into a list
  local tool_names = {}
  for tool_name, _ in pairs(unique_tool_names) do
    table.insert(tool_names, tool_name)
  end

  -- Sort alphabetically
  table.sort(tool_names)

  -- Convert into a comma-separated string
  return table.concat(tool_names, ', ')
end

local get_active_venv = function()
  if vim.bo.filetype ~= 'python' then return '' end
  if not vim.env.VIRTUAL_ENV then return '(no venv activated)' end
  return '(' .. vim.fs.basename(vim.env.VIRTUAL_ENV) .. ')'
end

return {
  'echasnovski/mini.statusline',
  opts = {
    content = {
      active = function()
        -- see: `:h MiniStatusline-example-content`
        -- see: https://github.com/echasnovski/mini.statusline/blob/main/lua/mini/statusline.lua#L606-L631
        local statusline = require('mini.statusline')

        -- Get strings to display
        local mode, mode_hl = statusline.section_mode({ trunc_width = 9999 }) -- always truncate to one letter
        local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 999 }) -- always truncate to just the filetype + icon
        local filepath = get_file_path()
        local location = '%2l:%-2v' -- LINE:COLUMN
        local macro_recording = macro_recording_in_progress()
        local tools_attached_to_buffer = get_attached_tools()
        local search = statusline.section_searchcount({ trunc_width = 75 })
        local venv = get_active_venv()

        -- Customize highlight group colors
        local mocha = require('catppuccin.palettes.mocha')
        vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { bg = 'none' }) -- no middle bg color across statusline
        vim.api.nvim_set_hl(0, 'MiniStatuslineLspServers', { bg = mocha.surface0 })
        vim.api.nvim_set_hl(0, 'MiniStatuslineDiagnostics', { fg = mocha.yellow })

        -- Compose strings into one big statusline string
        return statusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          '%<', -- Mark general truncate point
          { hl = 'MiniStatuslineFilename', strings = { filepath } },
          '%=', -- End left alignment
          { hl = mode_hl, strings = { macro_recording } },
          { hl = mode_hl, strings = { search } },
          { hl = 'MiniStatuslineDiagnostics', strings = { diagnostics } },
          { hl = 'MiniStatuslineLspServers', strings = { tools_attached_to_buffer } },
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo, venv } },
          { hl = mode_hl, strings = { location } },
        })
      end,
      inactive = function()
        -- see: https://github.com/echasnovski/mini.statusline/blob/main/lua/mini/statusline.lua#L633C30-L633C83
        return '%#MiniStatuslineInactive#%f%=' -- relative file path
      end,
    },
    set_vim_settings = false, -- don't override laststatus option
    use_icons = true,
  },
}
