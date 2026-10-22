-- Tests for the <c-h>/<c-j>/<c-k>/<c-l> mappings in lua/config/plugins/specs/vim-tmux-navigator.lua.
--
-- Run with: nvim --clean --headless -l tests/navigation_test.lua
--
-- Each test starts from two side-by-side windows with the cursor in the left one, sets $TMUX and
-- $REX_SESSION as the case needs, and presses one key by calling the mapping's function. vim.system
-- and vim.notify are stubbed, and fake TmuxNavigate* commands record what tmux would have been asked.

local repo = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
package.path = repo .. '/lua/?.lua;' .. package.path

local spec_module = 'config.plugins.specs.vim-tmux-navigator'

-- The spec decides its modes when it loads, so load it the way Neovim would outside tmux
local function load_spec(tmux)
  vim.env.TMUX = tmux
  package.loaded[spec_module] = nil
  return require(spec_module)
end

local spec = load_spec(nil)

local function mapping(lhs)
  for _, key in ipairs(spec.keys) do
    if key[1] == lhs then
      assert(type(key[2]) == 'function', lhs .. ' is mapped to ' .. vim.inspect(key[2]) .. ', not a function')
      return key[2]
    end
  end
  error(lhs .. ' is not mapped')
end

local recorded

local function fresh_state(env)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then vim.api.nvim_win_close(win, true) end
  end
  vim.cmd('silent! only')
  vim.cmd('enew!')
  vim.cmd('vsplit')
  vim.cmd('wincmd h')
  vim.env.TMUX = env.tmux
  vim.env.REX_SESSION = env.rex_session
  recorded = { tmux = {}, rex = {}, warnings = {} }
  for _, direction in ipairs({ 'Left', 'Down', 'Up', 'Right' }) do
    vim.api.nvim_create_user_command(
      'TmuxNavigate' .. direction,
      function() table.insert(recorded.tmux, direction) end,
      { force = true }
    )
  end
  vim.system = function(cmd, _, on_exit)
    table.insert(recorded.rex, cmd)
    if on_exit then on_exit({ code = env.rex_exit_code or 0, stdout = '', stderr = env.rex_stderr or '' }) end
    return {}
  end
  vim.notify = function(message, level)
    if level == vim.log.levels.WARN then table.insert(recorded.warnings, message) end
  end
end

local function press(lhs)
  mapping(lhs)()
  vim.wait(100, function() return false end) -- let scheduled callbacks run
end

local function window_side() return vim.fn.winnr() == 1 and 'left' or 'right' end

local function modes(lhs)
  for _, key in ipairs(spec.keys) do
    if key[1] == lhs then return key.mode end
  end
end

local function open_float()
  local buf = vim.api.nvim_create_buf(false, true)
  return vim.api.nvim_open_win(buf, true, { relative = 'editor', row = 0, col = 0, width = 40, height = 10 })
end

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

local function equal(actual, expected, what)
  if not vim.deep_equal(actual, expected) then
    error(string.format('%s: expected %s, got %s', what, vim.inspect(expected), vim.inspect(actual)), 2)
  end
end

test('inside tmux, ctrl+h and ctrl+l go to tmux and never to rex', function()
  fresh_state({ tmux = '/tmp/tmux-504/default,1,0', rex_session = 'session:test' })
  press('<c-l>')
  press('<c-h>')
  equal(recorded.tmux, { 'Right', 'Left' }, 'tmux calls')
  equal(recorded.rex, {}, 'rex calls')
end)

test('outside any multiplexer, ctrl+l moves to the next neovim window and starts nothing', function()
  fresh_state({})
  press('<c-l>')
  equal(window_side(), 'right', 'focused window')
  equal(recorded.rex, {}, 'rex calls')
end)

test('at the right edge inside rex, ctrl+l asks rex to focus right', function()
  fresh_state({ rex_session = 'session:test' })
  press('<c-l>')
  press('<c-l>')
  equal(#recorded.rex, 1, 'number of rex calls')
  local cmd = recorded.rex[1]
  equal({ cmd[1], cmd[2], cmd[3], cmd[4], cmd[5] }, { 'rex', 'do', '-s', 'session:test', '-e' }, 'rex command')
  assert(cmd[6]:find('direction = "right"', 1, true), 'script does not ask for right: ' .. cmd[6])
  assert(cmd[6]:find('wrap = true', 1, true), 'script does not wrap: ' .. cmd[6])
end)

test('at the left edge inside rex, ctrl+h asks rex to focus left', function()
  fresh_state({ rex_session = 'session:test' })
  press('<c-h>')
  equal(#recorded.rex, 1, 'number of rex calls')
  assert(recorded.rex[1][6]:find('direction = "left"', 1, true), 'script does not ask for left: ' .. recorded.rex[1][6])
end)

test('at the edge outside tmux and rex, nothing is started', function()
  fresh_state({})
  press('<c-h>')
  equal(window_side(), 'left', 'focused window')
  equal(recorded.rex, {}, 'rex calls')
  equal(recorded.tmux, {}, 'tmux calls')
end)

test('a failed rex call shows a warning with its stderr', function()
  fresh_state({ rex_session = 'session:test', rex_exit_code = 1, rex_stderr = 'session_not_found' })
  press('<c-h>')
  equal(#recorded.warnings, 1, 'number of warnings')
  assert(recorded.warnings[1]:find('session_not_found', 1, true), 'warning lacks stderr: ' .. recorded.warnings[1])
end)

test('outside tmux, ctrl+h and ctrl+l are also mapped in terminal mode', function()
  for _, lhs in ipairs({ '<c-h>', '<c-l>' }) do
    assert(vim.tbl_contains(modes(lhs), 't'), lhs .. ' modes: ' .. vim.inspect(modes(lhs)))
  end
end)

test('inside tmux, terminal mode keeps ctrl+h/j/k/l for the program in the terminal', function()
  local tmux_spec = load_spec('/tmp/tmux-504/default,1,0')
  for _, key in ipairs(tmux_spec.keys) do
    if vim.tbl_contains({ '<c-h>', '<c-j>', '<c-k>', '<c-l>' }, key[1]) then
      assert(not vim.tbl_contains(key.mode, 't'), key[1] .. ' modes: ' .. vim.inspect(key.mode))
    end
  end
  load_spec(nil)
end)

test('in a floating window inside rex, ctrl+l goes straight to rex and leaves focus in the float', function()
  fresh_state({ rex_session = 'session:test' })
  local float = open_float()
  press('<c-l>')
  equal(vim.api.nvim_get_current_win(), float, 'focused window')
  equal(#recorded.rex, 1, 'number of rex calls')
  assert(recorded.rex[1][6]:find('direction = "right"', 1, true), 'script does not ask for right: ' .. recorded.rex[1][6])
end)

test('in a floating window outside rex, ctrl+h leaves focus in the float', function()
  fresh_state({})
  local float = open_float()
  press('<c-h>')
  equal(vim.api.nvim_get_current_win(), float, 'focused window')
  equal(recorded.rex, {}, 'rex calls')
end)

test('in a split terminal, ctrl+l moves to the next neovim window', function()
  fresh_state({ rex_session = 'session:test' })
  vim.cmd('terminal')
  press('<c-l>')
  equal(window_side(), 'right', 'focused window')
  equal(recorded.rex, {}, 'rex calls')
end)

local vertical = { ['<c-j>'] = { tmux = 'Down', rex = 'down' }, ['<c-k>'] = { tmux = 'Up', rex = 'up' } }

test('inside tmux, ctrl+j and ctrl+k go to tmux', function()
  fresh_state({ tmux = '/tmp/tmux-504/default,1,0', rex_session = 'session:test' })
  press('<c-j>')
  press('<c-k>')
  equal(recorded.tmux, { 'Down', 'Up' }, 'tmux calls')
  equal(recorded.rex, {}, 'rex calls')
end)

test('outside any multiplexer, ctrl+j and ctrl+k move between stacked neovim windows', function()
  fresh_state({})
  vim.cmd('split') -- the left column is now two windows, cursor in the top one
  local top = vim.api.nvim_get_current_win()
  press('<c-j>')
  assert(vim.api.nvim_get_current_win() ~= top, 'ctrl+j did not leave the top window')
  press('<c-k>')
  equal(vim.api.nvim_get_current_win(), top, 'window after ctrl+k')
  equal(recorded.rex, {}, 'rex calls')
end)

test('at the top and bottom edges inside rex, ctrl+k and ctrl+j ask rex to focus up and down', function()
  for lhs, names in pairs(vertical) do
    fresh_state({ rex_session = 'session:test' })
    press(lhs)
    equal(#recorded.rex, 1, lhs .. ' rex calls')
    local script = recorded.rex[1][6]
    assert(script:find('direction = "' .. names.rex .. '"', 1, true), lhs .. ' script: ' .. script)
  end
end)

test('outside tmux, all four keys are mapped in terminal mode', function()
  for _, lhs in ipairs({ '<c-h>', '<c-j>', '<c-k>', '<c-l>' }) do
    assert(vim.tbl_contains(modes(lhs), 't'), lhs .. ' modes: ' .. vim.inspect(modes(lhs)))
  end
end)

test("the plugin's own mappings don't replace ours when it loads", function()
  local plugin = vim.fn.expand('~/.local/share/nvim-ide/lazy/vim-tmux-navigator/plugin/tmux_navigator.vim')
  assert(vim.fn.filereadable(plugin) == 1, 'plugin not installed at ' .. plugin .. '; open nvim-ide once to install it')
  for _, key in ipairs(spec.keys) do
    vim.keymap.set(key.mode, key[1], key[2]) -- as lazy.nvim does on startup
  end
  assert(type(spec.init) == 'function', 'spec has no init to switch off the plugin mappings')
  spec.init()
  vim.cmd('source ' .. plugin)
  for _, lhs in ipairs({ '<c-h>', '<c-j>', '<c-k>', '<c-l>' }) do
    equal(vim.fn.maparg(lhs, 'n', false, true).callback, mapping(lhs), lhs .. ' mapping after the plugin loads')
  end
end)

if failures > 0 then
  io.write(failures .. ' failed\n')
  os.exit(1)
end
io.write('all passed\n')
