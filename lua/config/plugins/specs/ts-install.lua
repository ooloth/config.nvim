---@module 'ts-install'

-- Manage Tree-sitter parser installations

-- DOCS: https://github.com/lewis6991/ts-install.nvim

-- Incremental treesitter node selection using native vim.treesitter API
-- Registered at module level so keymaps work even before ts-install.nvim is installed
local _selection_stack = {} -- { [bufnr] = { node, ... } }

local function select_node(node)
  local sr, sc, er, ec = node:range()
  -- treesitter: 0-indexed rows, 0-indexed byte cols, ec is exclusive end
  -- setpos: 1-indexed line, 1-indexed byte col
  vim.fn.setpos("'<", { 0, sr + 1, sc + 1, 0 })
  vim.fn.setpos("'>", { 0, er + 1, math.max(1, ec), 0 })
  -- \27 = Esc (exits any mode cleanly), then jump to '<, charwise visual, extend to '>
  -- Works identically whether called from normal or visual mode context
  vim.cmd('normal! \27`<v`>')
end

vim.keymap.set('n', '<cr>', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local node = vim.treesitter.get_node()
  if not node then return end
  _selection_stack[bufnr] = { node }
  select_node(node)
end, { desc = 'Start treesitter selection' })

vim.keymap.set('x', '<cr>', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local stack = _selection_stack[bufnr]
  if not stack or #stack == 0 then return end
  local parent = stack[#stack]:parent()
  if parent then
    table.insert(stack, parent)
    select_node(parent)
  end
end, { desc = 'Expand treesitter selection' })

vim.keymap.set('x', '<bs>', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local stack = _selection_stack[bufnr]
  if not stack or #stack <= 1 then return end
  table.remove(stack)
  select_node(stack[#stack])
end, { desc = 'Shrink treesitter selection' })

return {
  'lewis6991/ts-install.nvim',
  opts = {
    auto_install = true, -- install missing parser when entering a buffer
  },
  init = function()
    -- Enable treesitter highlighting and native indentation for all supported filetypes
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = 'v:lua.vim.treesitter.indentexpr()'
      end,
    })
  end,
}
