local dap = require('dap')
local dapui = require('dapui')

dapui.setup({
   layouts = {
      {
         elements = {
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "stacks",
            -- "watches",
         },
         size = 40, -- 40 columns
         position = "left",
      },
      {
         elements = {
            "watches",
            -- "console",
         },
         size = 0.25, -- 25% of total lines
         position = "bottom",
      },
   },
})

-- Set log level and file
dap.set_log_level('DEBUG')
local log_file_path = vim.fn.stdpath('data') .. '/dap.log'
dap.defaults.log_file = log_file_path

-- Function to print the log file location
local function print_log_file_path()
   print("DAP log file: " .. log_file_path)
end

-- Add a command to print the log file location
vim.api.nvim_create_user_command('PrintDapLogFile', print_log_file_path, {})

-- Automatically open and close the DAP UI
local function setup_dap_ui_listeners()
   dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
   end
   dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
   end
   dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
   end
end

setup_dap_ui_listeners()

-- Custom highlight groups for nvim-dap
local function set_custom_highlights()
   vim.api.nvim_set_hl(0, 'DapStoppedLine', { fg = 'black', bg = '#ecd49c', bold = true })
   vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = 'black', bg = '#ecd49c', bold = true })
   vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = 'black', bg = '#ecd49c', bold = true })
   vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = 'black', bg = '#ecd49c', bold = true })

   vim.fn.sign_define('DapStopped', { text = '→', texthl = 'DapStoppedLine', linehl = 'DapStoppedLine', numhl = '' })
   vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = 'DapBreakpoint' })
   vim.fn.sign_define('DapBreakpointCondition',
      { text = '◇', texthl = 'DapBreakpointCondition', linehl = '', numhl = 'DapBreakpointCondition' })
   vim.fn.sign_define('DapLogPoint', { text = '✎', texthl = 'DapLogPoint', linehl = '', numhl = 'DapLogPoint' })
end

-- Apply custom highlights on colorscheme change
vim.api.nvim_create_autocmd('ColorScheme', {
   callback = set_custom_highlights,
})

-- Apply custom highlights immediately
set_custom_highlights()

-- Configure nvim-dap-go with a timeout
require('dap-go').setup {
   delve = {
      initialize_timeout_sec = 20, -- Set timeout to 20 seconds
      port = "${port}",
   },
}

-- Configure the Lua adapter for debugging
dap.adapters.nlua = function(callback, config)
   local adapter = {
      type = 'server',
      host = config.host or '127.0.0.1',
      port = config.port or 8086,
   }
   if config.start_neovim then
      local dap_run = dap.run
      dap.run = function(c)
         adapter.port = c.port
         adapter.host = c.host
      end
      require('osv').run_this()
      dap.run = dap_run
   end
   callback(adapter)
end

dap.configurations.lua = {
   {
      type = 'nlua',
      request = 'attach',
      name = 'Run this file',
      start_neovim = {},
   },
   {
      type = 'nlua',
      request = 'attach',
      name = 'Attach to running Neovim instance (port = 8086)',
      port = 8086,
   },
}

-- DAP key mappings
vim.keymap.set('n', '<leader>dc', dap.continue, { noremap = true, silent = true, desc = "Debug: Continue Debugging" })
vim.keymap.set('n', '<leader>j', dap.step_over, { noremap = true, silent = true, desc = "Debug: Step Over" })
vim.keymap.set('n', '<leader>l', dap.step_into, { noremap = true, silent = true, desc = "Debug: Step Into" })
vim.keymap.set('n', '<leader>h', dap.step_out, { noremap = true, silent = true, desc = "Debug: Step Out" })
vim.keymap.set('n', '<leader>dd', dap.toggle_breakpoint,
   { noremap = true, silent = true, desc = "Debug: Toggle Breakpoint" })
vim.keymap.set('n', '<leader>db', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
   { noremap = true, silent = true, desc = "Debug: Set Conditional Breakpoint" })
vim.keymap.set('n', '<leader>dp', function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
   { noremap = true, silent = true, desc = "Debug: Set Log Point" })
-- vim.keymap.set('n', '<leader>dr', dap.repl.open, { noremap = true, silent = true, desc = "Debug: Open REPL" })
vim.keymap.set('n', '<leader>dr', dap.run_last,
   { noremap = true, silent = true, desc = "Debug: Run Last Debugging Session" })
vim.keymap.set('n', '<leader>dui', dapui.toggle, { noremap = true, silent = true, desc = "Debug: Toggle DAP UI" })
vim.keymap.set('n', '<leader>dq', function()
   dap.terminate()
   dapui.close()
end, { noremap = true, silent = true, desc = "Debug: Terminate Debugging Session" })
vim.keymap.set('n', '<leader>dx', dap.clear_breakpoints,
   { noremap = true, silent = true, desc = "Debug: Clear All Breakpoints" })
vim.keymap.set('n', '<leader>dt', require('dap-go').debug_test,
   { noremap = true, silent = true, desc = "Debug: Debug Test" })
