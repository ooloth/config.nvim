-- Tests for the colorscheme in lua/config/plugins/specs/catppuccin.lua.
--
-- Run with: nvim --clean --headless -l tests/colors_test.lua
--
-- Loads the installed catppuccin plugin, runs the spec's config, and reads back the highlights that
-- decide which backgrounds Neovim paints. Without a background, a window shows the terminal's own.

local repo = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
package.path = repo .. '/lua/?.lua;' .. package.path

local plugin = vim.fn.expand('~/.local/share/nvim-ide/lazy/catppuccin')
if vim.fn.isdirectory(plugin) == 0 then
  io.write('FAIL  catppuccin not installed at ' .. plugin .. '; open nvim-ide once to install it\n')
  os.exit(1)
end
vim.opt.rtp:prepend(plugin)

require('config.plugins.specs.catppuccin').config()

local failures = 0
local function test(name, fn)
  local ok, err = pcall(fn)
  if ok then
    io.write('ok    ' .. name .. '\n')
  else
    failures = failures + 1
    io.write('FAIL  ' .. name .. '\n      ' .. tostring(err) .. '\n')
  end
end

local function background(group)
  local bg = vim.api.nvim_get_hl(0, { name = group, link = false }).bg
  return bg and string.format('#%06x', bg) or 'none'
end

test('normal windows have no background of their own', function()
  for _, group in ipairs({ 'Normal', 'NormalNC' }) do
    assert(background(group) == 'none', group .. ' background is ' .. background(group))
  end
end)

test('floats have no background of their own', function()
  for _, group in ipairs({ 'NormalFloat', 'FloatBorder' }) do
    assert(background(group) == 'none', group .. ' background is ' .. background(group))
  end
end)

if failures > 0 then
  io.write(failures .. ' failed\n')
  os.exit(1)
end
io.write('all passed\n')
