-- DOCS: https://github.com/folke/noice.nvim
-- DOCS: https://github.com/folke/noice.nvim/wiki/Configuration-Recipes
-- DOCS: https://www.lazyvim.org/plugins/ui#noicenvim

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim', -- used for proper rendering and multiple views
    { 'rcarriga/nvim-notify', opts = { background_colour = '#1A1A28' } }, -- use as vim.notify UI
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    lsp = {
      hover = {
        opts = {
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
        },
      },
      override = {
        -- override markdown rendering so that nvim-cmp and other plugins use Treesitter
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
    },
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    routes = {
      {
        -- show @recording messages (https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#show-recording-messages)
        filter = { event = 'msg_showmode' },
        view = 'notify',
      },
      {
        -- send "written" messages to mini view instead of notify view (https://www.lazyvim.org/plugins/ui#noicenvim)
        filter = {
          event = 'msg_show',
          any = {
            { find = '%d+L, %d+B' },
            { find = '; after #%d+' },
            { find = '; before #%d+' },
          },
        },
        view = 'mini',
      },
    },
  },
  config = function(_, opts)
    -- HACK: noice shows messages from before it was enabled, but this is not ideal when Lazy is installing plugins, so clear the messages in this case
    if vim.o.filetype == 'lazy' then
      vim.cmd [[messages clear]]
    end
    require('noice').setup(opts)
  end,
}
