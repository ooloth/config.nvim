---@module 'mini.pairs'

-- Automatically insert pair of character

-- DOCS: `:h mini.pairs`
-- DOCS: https://github.com/echasnovski/mini.pairs
-- DOCS: https://www.lazyvim.org/plugins/coding#minipairs

return {
  'echasnovski/mini.pairs',
  opts = {
    modes = {
      insert = true,
      command = true,
      terminal = false,
    },
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=], -- skip autopair when next character is one of these
    skip_ts = { 'string' }, -- skip autopair when the cursor is inside these treesitter nodes
    skip_unbalanced = true, -- skip autopair when next character is closing pair and there are more closing pairs than opening pairs
    markdown = true, -- better deal with markdown code blocks
  },
}
