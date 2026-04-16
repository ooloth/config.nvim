-- TODO: https://www.lazyvim.org/extras/util/dot
-- TODO: dap?
-- https://www.reddit.com/r/neovim/comments/xzr6py/nvimdap_bash_debugging/
-- TODO: testing?

-- Tell treesitter to parse zsh like bash (until someone writes a zsh parser):
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/655#issuecomment-1476880919
vim.treesitter.language.register('bash', 'zsh')

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#bashls
        bashls = {},
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        bash = { 'shfmt' },
        sh = { 'shfmt' },
      },
    },
  },

  {
    'mfussenegger/nvim-lint',
    opts = {
      linters_by_ft = {
        bash = { 'shellcheck' },
        sh = { 'shellcheck' },
      },
    },
  },
}
