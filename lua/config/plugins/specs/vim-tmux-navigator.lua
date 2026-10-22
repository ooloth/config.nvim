---@module 'vim-tmux-navigator'

-- navigate vim splits (and tmux or rex panes) with <C-hjkl>

-- The plugin only hands focus to the multiplexer inside tmux. Elsewhere, at the edge of Neovim's splits,
-- <c-h/j/k/l> hand focus to the next Rex pane instead (see tools/rex/config/init.lua in the dotfiles repo).
-- A floating window, such as the lazygit popup, goes straight to Rex: wincmd from a float would move focus to a
-- window hidden behind it.
local directions = {
  h = { tmux = 'TmuxNavigateLeft', rex = 'left' },
  j = { tmux = 'TmuxNavigateDown', rex = 'down' },
  k = { tmux = 'TmuxNavigateUp', rex = 'up' },
  l = { tmux = 'TmuxNavigateRight', rex = 'right' },
}

local function navigate(direction)
  assert(directions[direction], 'unexpected direction: ' .. tostring(direction))
  local tmux_command = directions[direction].tmux
  local rex_direction = directions[direction].rex

  return function()
    if (vim.env.TMUX or '') ~= '' then
      vim.cmd(tmux_command)
      return
    end

    local in_float = vim.api.nvim_win_get_config(0).relative ~= ''
    if not in_float then
      local window_before = vim.fn.winnr()
      vim.cmd('wincmd ' .. direction)
      if vim.fn.winnr() ~= window_before then return end
    end

    local session = vim.env.REX_SESSION or ''
    if session == '' then return end

    local script = string.format('rex.session.focus_direction({ direction = "%s", wrap = true })', rex_direction)
    vim.system({ 'rex', 'do', '-s', session, '-e', script }, { text = true }, function(result)
      if result.code ~= 0 then
        vim.schedule(function()
          local message = string.format('rex focus %s failed (exit %d): %s', rex_direction, result.code, result.stderr)
          vim.notify(message, vim.log.levels.WARN)
        end)
      end
    end)
  end
end

-- Outside tmux, terminal mode is mapped too, so <c-h/j/k/l> also leave lazygit and other terminals.
-- Inside tmux, terminal programs keep the keys, as they always have.
local navigation_modes = (vim.env.TMUX or '') == '' and { 'n', 'x', 't' } or { 'n', 'x' }

return {
  'christoomey/vim-tmux-navigator',
  event = 'VeryLazy',
  -- otherwise the plugin's own <c-hjkl> mappings replace the ones in keys when it loads
  init = function() vim.g.tmux_navigator_no_mappings = 1 end,
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateRight',
    'TmuxNavigateUp',
    'TmuxNavigateDown',
    'TmuxNavigatePrevious',
  },
  keys = {
    { '<c-h>', navigate('h'), mode = navigation_modes },
    { '<c-j>', navigate('j'), mode = navigation_modes },
    { '<c-k>', navigate('k'), mode = navigation_modes },
    { '<c-l>', navigate('l'), mode = navigation_modes },
    { '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>', mode = { 'n', 'x' } },
  },
}
