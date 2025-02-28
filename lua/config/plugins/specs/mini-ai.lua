---@module 'mini.ai'

-- Extend and create a/i text objects
-- In addition to nvim-treesitter-textobjects, adds text objects like "b" (block) and "q" (quote)
-- Adds the "an/in" (around/inside next) and "al/il" (around/inside last) movements
--
-- Example:
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote

-- TODO: I ignored this incredible Neovim plugin for years! - https://www.youtube.com/watch?v=6V8jdqdygB4
-- DOCS: https://github.com/echasnovski/mini.ai?tab=readme-ov-file
-- DOCS: https://www.lazyvim.org/plugins/coding#miniai
-- CHAT: mini.ai vs. treesitter-textobjects for treesitter keymaps: https://github.com/echasnovski/mini.nvim/discussions/243

return {
  'echasnovski/mini.ai',
  event = 'VeryLazy',
  opts = {
    -- see: https://github.com/echasnovski/mini.ai?tab=readme-ov-file#default-config
    n_lines = 500,
  },
}
