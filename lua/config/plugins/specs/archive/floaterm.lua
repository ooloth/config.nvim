vim.g.floaterm_borderchars = ''
vim.g.floaterm_title = ''

-- track values I want to toggle
local state = {
  lazygit = {
    height = {
      current = '1.0',
      default = '1.0',
      max = '1.0',
    },
  },
  scratch = {
    height = {
      current = '0.3',
      default = '0.3',
      max = '1.0',
    },
  },
}

local options = {
  lazygit = {
    '--height=' .. state.lazygit.height.default,
    '--name=lazygit',
    '--width=1.0',
    'lazygit',
  },
  scratch = {
    '--borderchars=─',
    '--height=' .. state.scratch.height.default,
    '--name=scratch',
    '--position=bottom',
    '--width=1.0',
  },
}

-- see: https://github.com/voldikss/vim-floaterm/issues/409#issuecomment-2049837814
local function toggle_if_running_else_create(name)
  local is_running = vim.fn['floaterm#terminal#get_bufnr'](name) >= 0

  if not is_running then
    vim.cmd.FloatermNew(options[name])
    return
  end

  vim.cmd.FloatermToggle(name) -- toggle visibility
  vim.cmd.FloatermUpdate(options[name]) -- reapply initial options to restore initial dimensions after maximizing
end

local function toggle_maximized(name)
  local current_term_name = vim.fn['floaterm#config#get'](vim.fn.bufnr('%'), 'name')

  if name == current_term_name then
    -- if current_term_name ~= 'lazygit' then
    local height = state[name].height
    local new_height = height.current == height.max and height.default or height.max

    vim.cmd.FloatermUpdate('--height=' .. new_height)
    state[name].height.current = new_height
  end
end

return {
  'voldikss/vim-floaterm',
  event = 'VeryLazy',
  cmd = 'FloatermNew',
  keys = {
    { '<leader>gg', function() toggle_if_running_else_create('lazygit') end, desc = 'Lazygit' },
    { '<c-g>', function() toggle_if_running_else_create('lazygit') end, desc = 'Lazygit' },
    { '<c-t>', function() toggle_if_running_else_create('scratch') end, desc = 'Open scratch terminal' },
    { '<c-g>', mode = 't', '<cmd>FloatermHide<cr>', desc = 'Hide Lazygit' },
    { '<c-t>', mode = 't', '<cmd>FloatermHide<cr>', desc = 'Hide terminal' },
    { '<c-z>', mode = 't', function() toggle_maximized('scratch') end, desc = 'Toggle maximized terminal' },
  },
  init = function()
    -- Set float border to catppuccin mocha "surface1" color (used for split borders)
    vim.api.nvim_set_hl(0, 'FloatermBorder', { fg = '#45475a' })

    -- Remove ESC keymap in lazygit terminal
    vim.api.nvim_create_autocmd('User', {
      pattern = { 'FloatermOpen' },
      callback = function()
        local bufname = vim.fn.expand('%')

        -- Switch to normal mode with ESC...
        vim.keymap.set('t', '<esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })

        -- unless this is lazygit (which uses ESC internally)
        if string.find(bufname, 'lazygit') then vim.keymap.del('t', '<esc>') end
      end,
    })

    -- Automatically resize floating window if vim is resized
    -- see: https://github.com/voldikss/vim-floaterm/issues/296#issuecomment-1098841533
    vim.api.nvim_create_autocmd('VimResized', {
      callback = function()
        if vim.bo.filetype == 'floaterm' then vim.cmd.FloatermUpdate() end
      end,
    })
  end,
}
