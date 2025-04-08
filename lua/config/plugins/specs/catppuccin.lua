---@module 'catppuccin'

-- See: https://catppuccin.com/palette/
-- TODO: integrate with other plugins? https://github.com/catppuccin/nvim?tab=readme-ov-file#integrations

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  lazy = false,
  priority = 1000,
  config = function()
    -- see: https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
    require('catppuccin').setup({
      flavour = 'mocha', -- latte, frappe, macchiato, mocha
      -- see: https://github.com/catppuccin/nvim#integrations
      integrations = {
        aerial = true,
        cmp = true,
        -- flash = true,
        gitsigns = true,
        -- harpoon = true,
        -- headlines = true,
        -- illuminate = true,
        -- indent_blankline = { enabled = true },
        -- leap = true,
        lsp_trouble = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          inlay_hints = {
            background = true,
          },
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
        },
        neotest = true,
        noice = true,
        octo = true,
        semantic_tokens = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      transparent_background = true, -- disables setting the background color.
      -- styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
      --   booleans = {},
      --   comments = { 'italic' }, -- Change the style of comments
      --   conditionals = { 'italic' },
      --   functions = {},
      --   keywords = {},
      --   loops = {},
      --   numbers = {},
      --   operators = {},
      --   -- miscs = {}, -- Uncomment to turn off hard-coded styles
      -- },
      --   properties = {},
      --   strings = {},
      --   types = {},
      --   variables = {},
    })

    -- Must call after setup
    vim.cmd.colorscheme('catppuccin')

    local mocha = require('catppuccin.palettes.mocha')

    -- Non-italic diagnostic counts in statusline
    vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = mocha.red, italic = false })
    vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = mocha.teal, italic = false })
    vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = mocha.sky, italic = false })
    vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = mocha.yellow, italic = false })

    -- Subtle background instead of underline
    vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = '#232333' }) -- 25% of way from base to surface0
    vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { bg = '#232333' })

    -- More noticeable than default comment color
    vim.api.nvim_set_hl(0, 'NvimDapVirtualText', { fg = mocha.subtext0 })
  end,
}
