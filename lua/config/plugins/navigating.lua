-- Folding defaults (currently overridden as needed by nvim-ufo)
vim.opt.foldcolumn = '0'
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = 'indent'
vim.opt.foldtext = ''

vim.opt.mouse = '' -- disable mouse mode (set to 'a' to enable)
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
vim.opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode

local set = vim.keymap.set

-- swap : and ,
set({ 'n', 'v' }, ',', ':') -- enter command mode with , instead of :
set({ 'n', 'v' }, ':', ',') -- navigate f and t results using ;/: (like n/N for / results)

-- better up/down navigation
set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- navigate to beginning + end of line
set({ 'n', 'v' }, '<S-h>', '^', { silent = true })
set({ 'n', 'v' }, '<S-l>', '$', { silent = true })

-- navigate changes
set('n', ']c', 'g,', { desc = 'Next change' }) -- go to next change with g;
set('n', '[c', 'g;', { desc = 'Prev change' }) -- go to next change with g;
set('n', 'g;', 'g,', { desc = 'Next change' }) -- go to next change with g;
set('n', 'g:', 'g;', { desc = 'Prev change' }) -- go to previous change with g;

-- navigate editors (buffers)
-- WARN: don't try to add c-[] maps (c-[ means ESC; c-] navigates to :help keywords)
set('n', '<tab>', '<cmd>bn<cr>', { desc = 'Next editor' })
set('n', '<s-tab>', '<cmd>bp<cr>', { desc = 'Prev editor' })
set('n', '<leader>`', '<cmd>e#<cr>', { desc = 'Other editor' }) -- switch to last buffer
set('n', '<leader>ed', '<cmd>bp|bd #<cr>', { desc = 'Close editor' }) -- close buffer but not window
set('n', '<leader>ee', '<cmd>e#<cr>', { desc = 'Other editor' }) -- switch to last buffer
set('n', '<leader>en', '<cmd>bn<cr>', { desc = 'Next editor' })
set('n', '<leader>ep', '<cmd>bp<cr>', { desc = 'Prev editor' })
-- Close all buffers except the current one (like leader-wo does for windows):
-- https://stackoverflow.com/a/42071865/8802485
set('n', '<leader>eo', '<cmd>%bd|e#|bd#<cr>', { desc = 'Only keep this editor' })
set('n', '<leader>eu', '<cmd>e#<cr>', { desc = 'Undo close editor' }) -- fakes this by opening last buffer (same as switch maps above); doesn't actually reopen last closed editor if others have since been visited

-- navigate to location list
set('n', 'gl', '<cmd>lopen<cr>', { desc = 'Location list' })

-- navigate to quickfix list
set('n', 'gq', '<cmd>botright copen<cr>', { desc = 'Quickfix list' })

-- navigate out of neovim
set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit All' })

-- navigate tabs
set('n', ']<tab>', '<cmd>tabnext<cr>', { desc = 'Next tab' })
set('n', '[<tab>', '<cmd>tabprevious<cr>', { desc = 'Next tab' })
set('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New tab' })
set('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next tab' })
set('n', '<leader><tab>n', '<cmd>tabnext<cr>', { desc = 'Next tab' })
set('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Prev tab' })
set('n', '<leader><tab>p', '<cmd>tabprevious<cr>', { desc = 'Prev tab' })
set('n', '<leader><tab>o', '<cmd>tabonly<cr>', { desc = 'Close other tabs' })
set('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close tab' })
set('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First tab' })
set('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last tab' })

-- "window"
set('n', '<leader>\\', '<c-w>v', { desc = 'Split right' })
set('n', '<leader>-', '<c-w>s', { desc = 'Split below' })
set('n', '<leader>=', '<c-w>=', { desc = 'Resize equally' })
set('n', '<leader>[', '<cmd>vertical resize -3<cr>', { desc = 'Reduce size' })
set('n', '<leader>]', '<cmd>vertical resize +3<cr>', { desc = 'Increase size' })
set('n', '<leader>wd', '<c-w>c', { desc = 'Delete Window', remap = true })
-- NOTE: "leader-wm" = toggle maximize window (see snacks-zen.lua}
set('n', '<leader>wt', '<cmd>tab split<cr>', { desc = 'Open in new tab' })
set('n', '<leader>ww', '<c-w>p', { desc = 'Other Window', remap = true })
-- TODO: "leader-ww" = pick window (see nvim-window-picker.lua)?

-- new file

-- lazy
set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

set('n', '[q', vim.cmd.cprev, { desc = 'Prev Quickfix' })
set('n', ']q', vim.cmd.cnext, { desc = 'Next Quickfix' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
set('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
set('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
set('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
set('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })
set('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

---@class OpenInSplitOptions
---@field direction string: 'left' or 'right'

---Open the current buffer in a vertical split to the left or right.
---@param options OpenInSplitOptions
local function open_in_split(options)
  local opts = options or {}
  local direction = opts.direction or 'right' -- TODO: support up/down?

  local current_bufnr = vim.api.nvim_get_current_buf()
  local current_winnr = vim.api.nvim_get_current_win()

  local still_in_same_window = function() return vim.api.nvim_get_current_win() == current_winnr end

  if direction == 'right' then
    vim.cmd('wincmd l') -- try to move one window to the right
    if still_in_same_window() then
      vim.cmd('vsplit') -- create vertical split and move into it
    end
  elseif direction == 'left' then
    vim.cmd('wincmd h') -- try to move one window to the left
    if still_in_same_window() then
      vim.cmd('vsplit') -- create vertical split and move into it
      vim.cmd('wincmd h') -- move back to window on left (technically the original window, but conceptually the new one)
    end
  end

  vim.cmd('buffer ' .. current_bufnr) -- open current buffer in new window
  vim.cmd('wincmd p') -- move to original window
  vim.cmd('b#') -- show the previous buffer
  vim.cmd('wincmd p') -- move to new window
end

set('n', '<leader>eh', function() open_in_split({ direction = 'left' }) end, { desc = 'Move one split left', silent = true })
set('n', '<leader>el', function() open_in_split({ direction = 'right' }) end, { desc = 'Move one split right', silent = true })

return {
  require('config.plugins.specs.mini-files'), -- file system editor + explorer
  require('config.plugins.specs.nvim-ufo'), -- better folding
  require('config.plugins.specs.persistence'), -- session manager
  require('config.plugins.specs.vim-tmux-navigator'), -- move across vim + tmux windows with c-jkhl
}
