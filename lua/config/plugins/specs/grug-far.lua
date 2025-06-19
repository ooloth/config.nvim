-- TODO: https://www.youtube.com/watch?v=AK1TSwJrB3k

return {
  'MagicDuck/grug-far.nvim',
  config = function()
    -- vim.api.nvim_create_autocmd('FileType', {
    --   group = vim.api.nvim_create_augroup('grug-far-keybindings', { clear = true }),
    --   pattern = { 'grug-far' },
    --   callback = function()
    --     local inst = require('grug-far').get_instance(0)
    --     if not inst then return end
    --
    --     vim.g.maplocalleader = 'g'
    --     -- vim.keymap.set('n', '<C-enter>', function()
    --     --   inst:open_location()
    --     --   inst:close()
    --     -- end, { buffer = true })
    --   end,
    -- })

    require('grug-far').setup({
      -- Defaults: https://github.com/MagicDuck/grug-far.nvim/blob/main/lua/grug-far/opts.lua
      helpLine = {
        enabled = true,
      },
      showCompactInputs = true,
      showInputsTopPadding = false,
      showInputsBottomPadding = false,
      keymaps = {
        abort = { n = '<localleader>b' },
        applyNext = { n = '<localleader>j' },
        applyPrev = { n = '<localleader>k' },
        close = { n = 'q' },
        gotoLocation = { n = '<enter>' },
        help = { n = 'g?' },
        historyAdd = { n = '<localleader>a' },
        historyOpen = { n = '<localleader>t' },
        nextInput = { n = '<tab>' },
        openLocation = { n = '<localleader>o' },
        openNextLocation = { n = '<down>' },
        openPrevLocation = { n = '<up>' },
        pickHistoryEntry = { n = '<enter>' },
        previewLocation = { n = '<localleader>i' },
        prevInput = { n = '<s-tab>' },
        qflist = { n = '<localleader>q' },
        refresh = { n = '<localleader>f' },
        replace = { n = '<localleader>r' },
        swapEngine = { n = '<localleader>e' },
        swapReplacementInterpreter = { n = '<localleader>x' },
        syncFile = { n = '<localleader>v' },
        syncLine = { n = '<localleader>l' },
        syncLocations = { n = '<localleader>s' },
        syncNext = { n = '<localleader>n' },
        syncPrev = { n = '<localleader>p' },
        toggleShowCommand = { n = '<localleader>w' },
      },
    })
  end,
}
