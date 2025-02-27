-- TODO: folding: Code Folding in Neovim: https://www.youtube.com/watch?v=f_f08KnAJOQ (recommends nvim-ufo over other options like treesitter)
-- TODO: folding: https://github.com/kevinhwang91/nvim-ufo
-- TODO: folding: Configuring nvim-ufo to use LSP with lazy.nvim: https://www.reddit.com/r/neovim/comments/12yomtj/configuring_nvimufo_to_use_lsp_with_lazynvim/

return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
  },
  config = function()
    -- see: https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#minimal-configuration
    vim.o.foldcolumn = '0'
    vim.o.foldlevel = 99 -- ufo provider needs a large value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require('ufo').setup({
      -- see: https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#customize-configuration
      -- close_fold_kinds_for_ft = {
      --   default = { 'imports' }, -- auto fold imports
      --   json = {},
      --   python = { 'imports' },
      -- },
      -- provider_selector = function() return { 'treesitter', 'indent' } end,
    })
  end,
}
