-- Tests for lua/config/plugins/specs/persistence.lua.
--
-- Run with: nvim --clean --headless -l tests/persistence_test.lua
--
-- This runs headless, so it checks the headless half only: vim.v.argv is read-only, so a test
-- can't see the spec as a Neovim with a UI would.

local repo = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
package.path = repo .. '/lua/?.lua;' .. package.path

local spec = require('config.plugins.specs.persistence')

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

test('headless Neovim does not load persistence, so it never restores or saves a session', function()
  assert(vim.tbl_contains(vim.v.argv, '--headless'), 'this test must run under --headless')
  assert(spec.cond == false, 'expected cond == false, got ' .. vim.inspect(spec.cond))
end)

if failures > 0 then
  io.write(failures .. ' failed\n')
  os.exit(1)
end
io.write('all passed\n')
