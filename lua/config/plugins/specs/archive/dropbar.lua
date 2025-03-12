-- TODO: show just the path breadcrumbs in inactive windows: https://github.com/Bekaboo/dropbar.nvim/discussions/60

return {
  'Bekaboo/dropbar.nvim',
  dependencies = {
    'nvim-web-devicons',
  },
  config = function()
    local opts = {
      sources = {
        path = {
          max_depth = 0, -- no path
        },
      },
    }

    local valid_types = require('dropbar.configs').opts.sources.treesitter.valid_types

    for i, t in ipairs(valid_types) do
      -- Don't add python imports to breadcrumbs when at the root of a module
      -- https://github.com/Bekaboo/dropbar.nvim/discussions/216
      if t == 'module' then
        table.remove(valid_types, i)
        break
      end
    end

    require('dropbar').setup(opts)
  end,
}
