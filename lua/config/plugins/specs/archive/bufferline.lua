return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  dependencies = {
    'catppuccin/nvim',
    'tiagovla/scope.nvim',
  },
  opts = function()
    -- see `:h bufferline-configuration`
    local mocha_custom_bg = '#1A1A28'

    return {
      -- see: https://github.com/catppuccin/nvim?tab=readme-ov-file#integrations
      highlights = require('catppuccin.groups.integrations.bufferline').get({
        custom = {
          mocha = {
            separator_selected = { fg = mocha_custom_bg },
            separator_visible = { fg = mocha_custom_bg },
            separator = { fg = mocha_custom_bg },
          },
        },
      }),
      options = {
        always_show_bufferline = true,
        diagnostics = 'nvim_lsp', -- indicate diagnostic issues
        indicator = { style = 'none' },
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    }
  end,
  init = function()
    -- Only show the current tab's buffers in bufferline
    require('scope').setup()
  end,
}
