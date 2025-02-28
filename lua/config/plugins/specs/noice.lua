---@module 'noice'

-- TODO: still want?
-- TODO: how to dismiss a notification immediately if I want to?
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
      command_palette = true, -- position the cmdline and popupmenu together
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
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
  keys = {
    -- stylua: ignore start
    { "<c-d>", function() if not require("noice.lsp").scroll(4) then return "<c-d>" end end, silent = true, expr = true, desc = "Scroll Noice Float Forward", mode = {"i", "n", "s"} },
    { "<c-u>", function() if not require("noice.lsp").scroll(-4) then return "<c-u>" end end, silent = true, expr = true, desc = "Scroll Noice Float Backward", mode = {"i", "n", "s"}},
    -- stylua: ignore end
  },
  config = function(_, opts)
    -- HACK: noice shows messages from before it was enabled, but this is not ideal when Lazy is installing plugins, so clear the messages in this case
    if vim.o.filetype == 'lazy' then vim.cmd([[messages clear]]) end
    require('noice').setup(opts)
  end,
}
