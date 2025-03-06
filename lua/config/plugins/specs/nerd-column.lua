return {
  'hankertrix/nerd_column.nvim',
  event = { 'BufEnter' },
  opts = {
    colour_column = 120,
    custom_colour_column = {
      lua = 130,
    },
    disabled_filetypes = { 'help', 'text', 'markdown' },
    respect_editor_config = true,
    scope = 'file',
  },
}
