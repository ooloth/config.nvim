---@module 'codecompanion'

return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    -- see: https://codecompanion.olimorris.dev/installation.html#installation-1
    {
      'nvim-lua/plenary.nvim',
      branch = 'master', -- resolves "buffer not modifiable" after first chat question: https://github.com/olimorris/codecompanion.nvim/issues/377#issuecomment-2443121875
    },
    'zbirenbaum/copilot.lua',
  },
  keys = {
    { '<leader>a,', '<cmd>CodeCompanionActions<cr>', desc = 'CodeCompanion actions', mode = { 'n', 'x' } },
    { '<leader>aa', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Chat editor (toggle)', mode = { 'n', 'x' } },
    { '<leader>ai', '<cmd>CodeCompanion<cr>', desc = 'Inline assistant', mode = { 'n', 'x' } },
    { '<leader>as', '<cmd>CodeCompanionChat Add<cr>', desc = 'Send selection to chat', mode = 'x' },
  },
  opts = {
    display = {
      chat = {
        show_settings = false, -- show LLM settings at the top of the chat buffer?
        show_token_count = true, -- show the token count for each response?
        -- start_in_insert_mode = true, -- open the chat buffer in insert mode?
        window = { width = 0.45 },
      },
    },
    strategies = {
      chat = {
        keymaps = {
          close = {
            modes = { n = { 'q' }, i = '<c-c>' },
            -- Toggle instead of closing to avoid losing this session's chat history
            callback = function() require('codecompanion').toggle() end,
            description = 'Toggle Chat',
          },
          completion = {
            modes = { i = '<c-s>' },
          },
          send = {
            modes = { n = '<cr>', i = '<c-l>' },
          },
        },
      },
      inline = {
        keymaps = {
          accept_change = {
            modes = { n = 'ga' },
            description = 'Accept the suggested change',
          },
          reject_change = {
            modes = { n = 'gr' },
            description = 'Reject the suggested change',
          },
        },
      },
    },
  },
  init = function()
    vim.cmd([[cab cc CodeCompanion]]) -- expand 'cc' into 'CodeCompanion' in the neovim command prompt
  end,
}
