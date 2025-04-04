---@module 'inc-rename'

-- Shows LSP symbol rename changes in progress as each character is typed
-- Input pop-up provided by noice.nvim integration (see noice settings)

-- NOTE: the rename window is in command mode the whole time (not insert mode), which is required to support the previews of the
-- effects to the command in the buffer. That's why switching to normal mode with <esc> is not possible.
-- See: https://github.com/smjonas/inc-rename.nvim/issues/58

return {
  'smjonas/inc-rename.nvim',
  opts = {
    preview_empty_name = true,
  },
}
