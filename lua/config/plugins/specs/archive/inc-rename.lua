---@module 'inc-rename'

-- NOTE: I archived this because by using vim.lsp.buf.rename directly, I get the ability to use normal mode with <esc>.

-- Shows LSP symbol rename changes in progress as each character is typed
-- Input pop-up provided by noice.nvim integration (see noice settings)

-- NOTE: the rename window is in command mode the whole time (not insert mode), which is required to support the previews of the
-- effects to the command in the buffer. That's why switching to normal mode with <esc> is not possible.
-- See: https://github.com/smjonas/inc-rename.nvim/issues/58

-- NOTE: press <c-f> while in the rename window to open the command line window in normal mode for easier editing. Press <cr>
-- while in insert mode to apply the changes and close. Press <c-c> to return to the rename window.
-- See: https://stackoverflow.com/questions/6920943/navigating-in-vims-command-mode
-- See: https://stackoverflow.com/questions/7186880/using-normal-mode-motions-in-command-line-mode-in-vim/7189573#7189573

return {
  'smjonas/inc-rename.nvim',
  opts = {
    preview_empty_name = true,
    post_hook = function() vim.cmd('wa') end, -- save all buffers after renaming
  },
}
