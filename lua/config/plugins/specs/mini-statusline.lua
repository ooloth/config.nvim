---@module 'mini.statusline'
---@module 'dropbar'

-- TODO: show attached formatters as well: https://gist.github.com/Lamarcke/36e086dd3bb2cebc593d505e2f838e07
-- TODO: show @recording messages in statusline instead of notify pop-ups? https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#show-recording-messages
-- TODO: sort all attached lsp servers, formatters, and linters alphabetically

local get_attached_tools = function()
  local lsp_servers_attached_to_this_buffer = vim.lsp.get_clients({ bufnr = vim.fn.bufnr('%') })

  -- NOTE: nvim-lint doesn't provide a way confirm which linters are "attached"; just which are configured
  -- see: https://github.com/mfussenegger/nvim-lint/issues/559#issuecomment-2010049274
  local linters_configured_for_this_filetype = require('lint').linters_by_ft[vim.bo.filetype] or {}

  -- Use a table's keys to track unique tool names (to prevent duplicates from accumulating)
  local unique_tool_names = {}

  -- Add linters to the unique tool names
  for _, linter in ipairs(linters_configured_for_this_filetype) do
    unique_tool_names[linter] = true
  end

  -- Add LSP clients to the unique tool names
  for _, lsp_client in ipairs(lsp_servers_attached_to_this_buffer) do
    unique_tool_names[lsp_client.name] = true
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

  -- TODO: need anymore with uv?
  -- example path (pyenv) = '/Users/michael/.pyenv/versions/3.12.1/envs/scraper'
  -- example path (uv) = '/Users/michael/Repos/ooloth/some-python-project/.venv'
  return '(' .. vim.fs.basename(vim.env.VIRTUAL_ENV) .. ')'
end

return {
  'echasnovski/mini.statusline',
  dependencies = {
    'Bekaboo/dropbar.nvim',
  },
  opts = {
    content = {
      active = function()
        -- see: `:h MiniStatusline-example-content`
        -- see: https://github.com/echasnovski/mini.statusline/blob/main/lua/mini/statusline.lua#L606-L631
        local statusline = require('mini.statusline')

        -- Get strings to display
        local mode, mode_hl = statusline.section_mode({ trunc_width = 9999 }) -- always truncate to one letter
        local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
        local filename = statusline.section_filename({ trunc_width = 999 }) -- always truncate to the relative path
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 999 }) -- always truncate to just the filetype + icon
        local location = '%2l:%-2v' -- LINE:COLUMN
        -- See: https://github.com/echasnovski/mini.statusline/blob/main/lua/mini/statusline.lua#L433
        -- local location = '%l/%L %2v/%-2{virtcol("$") - 1}' -- LINE/LINES COLUMN/COLUMNS
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
          _G.dropbar(),
          -- { hl = 'MiniStatuslineFilename', strings = { filename } },
          '%=', -- End left alignment
          { hl = mode_hl, strings = { search } },
          { hl = 'MiniStatuslineDiagnostics', strings = { diagnostics } },
          { hl = 'MiniStatuslineLspServers', strings = { tools_attached_to_buffer } },
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo, venv } },
          { hl = mode_hl, strings = { location } },
        })
      end,
      inactive = function()
        -- return _G.dropbar()
        -- see: https://github.com/echasnovski/mini.statusline/blob/main/lua/mini/statusline.lua#L633C30-L633C83
        return '%#MiniStatuslineInactive#%f%=' -- show relative file path instead of absolute path
      end,
    },
    set_vim_settings = false, -- don't override laststatus option
    use_icons = true,
  },
}
