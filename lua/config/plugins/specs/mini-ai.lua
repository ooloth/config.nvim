---@module 'mini.ai'

-- Extend and create a/i text objects
-- See: https://github.com/nvim-mini/mini.ai#installation
-- Provides treesitter-backed textobjects (f/c) plus extras like "b" (block) and "q" (quote)
-- Adds the "an/in" (around/inside next) and "al/il" (around/inside last) movements
--
-- Example:
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote

-- TODO: I ignored this incredible Neovim plugin for years! - https://www.youtube.com/watch?v=6V8jdqdygB4
-- DOCS: https://github.com/echasnovski/mini.ai?tab=readme-ov-file
-- DOCS: https://www.lazyvim.org/plugins/coding#miniai
-- CHAT: mini.ai vs. treesitter-textobjects for treesitter keymaps: https://github.com/echasnovski/mini.nvim/discussions/243

return {
  'nvim-mini/mini.ai',
  version = false, -- latest
  event = 'VeryLazy',
  dependencies = {
    -- Provides queries/{lang}/textobjects.scm files that define @function.outer/inner, @class.outer/inner, etc.
    -- Only its runtime query files are used — its Lua modules are never loaded.
    -- This does NOT reintroduce nvim-treesitter; ts-install.nvim manages parser installation.
    -- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main', lazy = true },
  },
  opts = function()
    local ai = require('mini.ai')
    return {
      -- see: https://github.com/echasnovski/mini.ai?tab=readme-ov-file#default-config
      n_lines = 500,
      custom_textobjects = {
        f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
      },
    }
  end,
}
