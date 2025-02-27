-- TODO: never format while I'm in insert mode
return {
  'okuuva/auto-save.nvim',
  version = '*',
  event = { 'InsertLeave', 'TextChanged' }, -- optional for lazy loading on trigger events
  opts = {
    -- see: https://github.com/okuuva/auto-save.nvim
    condition = function()
      local file_is_mine = vim.bo.filetype ~= '' and vim.bo.buftype == ''
      return file_is_mine
    end,
    debounce_delay = 500, -- 3000 made me race to avoid formatting happening while I was typing (try short or very long)
  },
}
