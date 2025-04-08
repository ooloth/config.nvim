return {
  'felpafel/inlay-hint.nvim',
  event = 'LspAttach',
  opts = {
    -- Position of virtual text. Possible values:
    -- 'eol': right after eol character (default).
    -- 'right_align': display right aligned in the window.
    -- 'inline': display at the specified column, and shift the buffer
    -- text to the right as needed.
    virt_text_pos = 'eol',
  },
}
