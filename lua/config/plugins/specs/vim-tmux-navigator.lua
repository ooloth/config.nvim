---@module 'vim-tmux-navigator'

-- navigate vim splits (and tmux or rex panes) with <C-hjkl>

-- The plugin only hands focus to the multiplexer inside tmux. Elsewhere, at the edge of Neovim's splits,
-- <c-h>/<c-l> hand focus to the next Rex pane instead (see tools/rex/config/init.lua in the dotfiles repo).
-- A floating window, such as the lazygit popup, goes straight to Rex: wincmd from a float would move focus to a
-- window hidden behind it.
local function navigate_horizontally(direction)
  assert(direction == 'h' or direction == 'l', 'unexpected direction: ' .. tostring(direction))
  local tmux_command = direction == 'h' and 'TmuxNavigateLeft' or 'TmuxNavigateRight'
  local rex_direction = direction == 'h' and 'left' or 'right'

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

-- Outside tmux, terminal mode is mapped too, so <c-h>/<c-l> also leave lazygit and other terminals.
-- Inside tmux, terminal programs keep the keys, as they always have.
local horizontal_modes = (vim.env.TMUX or '') == '' and { 'n', 'x', 't' } or { 'n', 'x' }

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
    { '<c-h>', navigate_horizontally('h'), mode = horizontal_modes },
    { '<c-l>', navigate_horizontally('l'), mode = horizontal_modes },
    { '<c-k>', '<cmd>TmuxNavigateUp<cr>', mode = { 'n', 'x' } },
    { '<c-j>', '<cmd>TmuxNavigateDown<cr>', mode = { 'n', 'x' } },
    { '<c-\\>', '<cmd>TmuxNavigatePrevious<cr>', mode = { 'n', 'x' } },
  },
}
