---@module 'dap-view'

return {
  'igorlfs/nvim-dap-view',
  opts = {
    winbar = {
      sections = { 'console', 'repl', 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads' },
      default_section = 'console',
      headers = {
        breakpoints = 'Breakpoints [B]',
        console = 'Terminal [T]',
        exceptions = 'Exceptions [E]',
        repl = 'REPL [R]',
        scopes = 'Variables [V]',
        threads = 'Stack frames [S]',
        watches = 'Watches [W]',
      },
    },
  },
  config = function(_, opts)
    local dap, dv = require('dap'), require('dap-view')
    dv.setup(opts)
    dap.listeners.before.attach['dap-view-config'] = dv.open
    dap.listeners.before.launch['dap-view-config'] = dv.open
    dap.listeners.before.event_terminated['dap-view-config'] = dv.close
    dap.listeners.before.event_exited['dap-view-config'] = dv.close
  end,
}
