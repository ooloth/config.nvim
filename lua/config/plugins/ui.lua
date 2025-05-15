vim.opt.background = 'dark' -- colorschemes that can be light or dark will be made dark
vim.opt.breakindent = true
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.cursorline = true -- highlight current line
vim.opt.fillchars = {
  -- foldopen = '',
  -- foldclose = '',
  -- fold = ' ',
  -- foldsep = ' ',
  diff = '╱',
  eob = ' ', -- hide ~ at end of buffer
}
vim.opt.laststatus = 2 -- always show statusline
vim.opt.linebreak = true -- if wrapping lines visually, wrap at readable points
vim.opt.list = true -- show invisible whitespace characters (tabs, etc)
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- define whitespace indicators
vim.opt.number = false -- show absolute line numbers
vim.opt.pumblend = 10 -- popup blend transparency (%)
vim.opt.pumheight = 15 -- maximum number of entries in a popup
vim.opt.relativenumber = false -- show relative line numbers
vim.opt.scrolloff = 15 -- lines of context kept onscreen
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true }) -- abbreviate some messages
vim.opt.showmode = false -- hide mode since it's already in the status line
vim.opt.sidescroll = 10
vim.opt.sidescrolloff = 10 -- columns of context kept onscreen
vim.opt.signcolumn = 'yes' -- always show signcolumn to avoid a layout shift
vim.opt.smoothscroll = true
vim.opt.splitbelow = true -- open horizontal splits below
vim.opt.splitkeep = 'screen'
vim.opt.splitright = true -- open vertical splits to the right
vim.opt.termguicolors = true -- support true colors
vim.opt.timeoutlen = 300 -- shorter mapped sequence wait time (displays which-key popup sooner)
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- disable line wrap

local set = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

local filetypes_that_should_never_have_line_numbers = {
  ['dap-repl'] = true,
  ['dapui_breakpoints'] = true,
  ['dapui_console'] = true,
  ['dapui_hover'] = true,
  ['dapui_scopes'] = true,
  ['dapui_stacks'] = true,
  ['dapui_watches'] = true,
}

local toggle_line_numbers_in_all_windows = function()
  -- If coming from relative line numbers, switch to absolute line numbers; otherwise toggle
  local new_line_number = vim.wo.relativenumber and true or not vim.wo.number
  local win_ids = vim.api.nvim_list_wins()

  for _, win_id in ipairs(win_ids) do
    local bufnr = vim.api.nvim_win_get_buf(win_id)
    local buffer_filetype = vim.bo[bufnr].filetype
    local is_filetype_to_skip = filetypes_that_should_never_have_line_numbers[buffer_filetype]

    if not is_filetype_to_skip then
      vim.api.nvim_set_option_value('number', new_line_number, { win = win_id })
      vim.api.nvim_set_option_value('relativenumber', false, { win = win_id }) -- always hide
    end
  end
end

local toggle_relative_line_numbers_in_all_windows = function()
  local current_relative_line_number = vim.wo.relativenumber

  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    if not filetypes_that_should_never_have_line_numbers[vim.bo[vim.api.nvim_win_get_buf(win_id)].filetype] then
      vim.api.nvim_set_option_value('relativenumber', not current_relative_line_number, { win = win_id })
      vim.api.nvim_set_option_value('number', not current_relative_line_number, { win = win_id }) -- keep in sync
    end
  end
end

set('n', '<leader>ul', toggle_line_numbers_in_all_windows, { desc = 'Line numbers (toggle)' })
set('n', '<leader>ur', toggle_relative_line_numbers_in_all_windows, { desc = 'Relative line numbers (toggle)' })

set('n', '<leader>uw', '<cmd>set wrap!<cr>', { desc = 'Line wrapping (toggle)' })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
set('n', '<leader>ud', '<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>', { desc = 'Draw screen again' })

-- Clear search highlights on <esc>
set({ 'i', 'n' }, '<esc>', '<cmd>nohlsearch<cr><esc>', { silent = true })

vim.cmd([[
  autocmd InsertEnter * set nocursorline
  autocmd InsertLeave * set cursorline
]])

autocmd('VimResized', {
  desc = 'Equalize splits after resizing Neovim window',
  callback = function() vim.cmd('wincmd =') end,
})

-- TODO: move to after/ftplugin?
autocmd('FileType', {
  desc = 'Enable wrap and spell-checking in these filetypes',
  pattern = { 'gitcommit', 'log', 'markdown', 'text' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

return {
  require('config.plugins.specs.catppuccin'),
  require('config.plugins.specs.dressing'),
  require('config.plugins.specs.fidget'),
  require('config.plugins.specs.mini-statusline'),
  require('config.plugins.specs.nerd-column'),
  require('config.plugins.specs.noice'),
  require('config.plugins.specs.nvim-treesitter-context'),
  require('config.plugins.specs.snacks-input'),
  require('config.plugins.specs.snacks-notifier'),
  require('config.plugins.specs.snacks-zen'),
  require('config.plugins.specs.todo-comments'),
  require('config.plugins.specs.which-key'),
}
