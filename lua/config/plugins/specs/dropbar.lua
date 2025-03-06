return {
  'Bekaboo/dropbar.nvim',
  dependencies = {
    'nvim-web-devicons',
  },
  config = function(_, opts)
    opts = opts or {}

    local sources = require('dropbar.sources')
    local utils = require('dropbar.utils')

    -- local markdown_breadcrumbs = {
    --   get_symbols = function(buf, win, _)
    --     return {}

    --     -- if vim.bo[buf].ft ~= 'markdown' then return {} end

    --     -- if vim.api.nvim_get_current_win() ~= win then return { sources.path } end

    --     -- return {
    --     --   sources.path,
    --     --   sources.markdown,
    --     -- }
    --   end,
    -- }

    -- local get_default_breadcrumbs = function(win)
    --   vim.print('win:' .. win)
    --   vim.print('current_win:' .. vim.api.nvim_get_current_win())
    --   if vim.api.nvim_get_current_win() ~= win then return { sources.path } end
    --
    --   return {
    --     sources.path,
    --     utils.source.fallback({
    --       sources.lsp,
    --       sources.treesitter,
    --     }),
    --   }
    -- end

    -- local default_breadcrumbs = {
    --   get_symbols = function(_, win, _)
    --     vim.print('win:' .. win)
    --     vim.print('current_win:' .. vim.api.nvim_get_current_win())

    --     if vim.api.nvim_get_current_win() ~= win then return sources.path.get_symbols() end

    --     local function flatten(list_of_lists)
    --       local flat_list = {}
    --       for _, list in ipairs(list_of_lists) do
    --         for _, item in ipairs(list) do
    --           table.insert(flat_list, item)
    --         end
    --       end
    --       return flat_list
    --     end

    --     return flatten({
    --       sources.path.get_symbols(),
    --       utils.source
    --         .fallback({
    --           sources.lsp,
    --           sources.treesitter,
    --         })
    --         .get_symbols(),
    --     })

    --     -- return {
    --     --   sources.path.get_symbols(),
    --     --   utils.source
    --     --     .fallback({
    --     --       sources.lsp,
    --     --       sources.treesitter,
    --     --     })
    --     --     .get_symbols(),
    --     -- }
    --   end,
    -- }

    -- local terminal_breadcrumbs = {
    --   get_symbols = function(buf, _, _)
    --     return {}
    --     -- if vim.bo[buf].buftype == 'terminal' then return { sources.terminal } end
    --   end,
    -- }

    opts.bar = {
      enable = false, -- disable interactive winbar in favor of readonly string in statusline
    }
    -- opts.sources = {
    --   path = {
    --     max_depth = 3,
    --   },
    -- }

    local valid_types = require('dropbar.configs').opts.sources.treesitter.valid_types

    for i, t in ipairs(valid_types) do
      -- Don't show python imports in dropbar
      -- https://github.com/Bekaboo/dropbar.nvim/discussions/216
      if t == 'module' then
        table.remove(valid_types, i)
        break
      end
    end

    require('dropbar').setup(opts)
  end,
}
