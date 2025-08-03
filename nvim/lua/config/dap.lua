local dap = require('dap')
local dapui = require('dapui')

dapui.setup({
   layouts = {
      {
         elements = {
            { id = "scopes", size = 1.0 }, -- hela ytan i botten
         },
         size = 0.25,                      -- 25% av editorhöjden
         position = "top",
      },
   },
})

require('nvim-dap-virtual-text').setup {
   enabled = true,
   commented = false,
   only_first_definition = true,
   all_references = false,
   only_current_line = true,
   show_stop_reason = true,
   show_changed_variables = true,
   virt_text_pos = 'eol', -- end of line
   highlight_changed_variables = true,
   highlight_new_as_changed = true,
}

-- Diskret färg för inline-text
vim.api.nvim_set_hl(0, "DapVirtualText", { fg = "#808080", italic = true })

-- Set log level and file
local log_file_path = vim.fn.stdpath('data') .. '/dap.log'
dap.set_log_level('DEBUG')
dap.defaults.log_file = log_file_path

vim.api.nvim_create_user_command('PrintDapLogFile', function()
   print("DAP log file: " .. log_file_path)
end, {})

-- Open/close UI automatically
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- Highlight groups and signs
local function set_custom_highlights()
   vim.api.nvim_set_hl(0, 'DapStoppedLine', { fg = 'black', bg = '#ecd49c', bold = true })
   vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = 'black', bg = '#ecd49c', bold = true })
   vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = 'black', bg = '#ecd49c', bold = true })
   vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = 'black', bg = '#ecd49c', bold = true })

   vim.fn.sign_define('DapStopped', { text = '→', texthl = 'DapStoppedLine', linehl = 'DapStoppedLine' })
   vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
   vim.fn.sign_define('DapBreakpointCondition',
      { text = '◇', texthl = 'DapBreakpointCondition', numhl = 'DapBreakpointCondition' })
   vim.fn.sign_define('DapLogPoint', { text = '✎', texthl = 'DapLogPoint', numhl = 'DapLogPoint' })
end

vim.api.nvim_create_autocmd('ColorScheme', {
   callback = set_custom_highlights,
})
set_custom_highlights()

-- DAP-go setup
require('dap-go').setup {
   delve = {
      initialize_timeout_sec = 20,
      port = "${port}",
   },
}

-- Lua adapter
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

-- Keymaps
vim.keymap.set('n', '<leader>dk', dap.run_to_cursor,
   { desc = "Debug: Run to Cursor" })
vim.keymap.set('n', '<leader>dl', function()
   vim.cmd("PrintDapLogFile")
   vim.cmd("edit " .. log_file_path)
end, { desc = "Debug: Open DAP Log File" })

vim.keymap.set('n', '<leader>dc', dap.continue, { desc = "Debug: Continue Debugging" })
vim.keymap.set('n', '<leader>j', dap.step_over, { desc = "Debug: Step Over" })
vim.keymap.set('n', '<leader>l', dap.step_into, { desc = "Debug: Step Into" })
vim.keymap.set('n', '<leader>h', dap.step_out, { desc = "Debug: Step Out" })
vim.keymap.set('n', '<leader>dd', dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set('n', '<leader>db', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
   { desc = "Debug: Set Conditional Breakpoint" })
vim.keymap.set('n', '<leader>dp', function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
   { desc = "Debug: Set Log Point" })
vim.keymap.set('n', '<leader>dr', dap.run_last, { desc = "Debug: Run Last Debugging Session" })
vim.keymap.set('n', '<leader>dui', dapui.toggle, { desc = "Debug: Toggle DAP UI" })
vim.keymap.set('n', '<leader>dq', function()
   dap.terminate(); dapui.close()
end, { desc = "Debug: Terminate Debugging Session" })
vim.keymap.set('n', '<leader>dx', dap.clear_breakpoints, { desc = "Debug: Clear All Breakpoints" })
vim.keymap.set('n', '<leader>dt', require('dap-go').debug_test, { desc = "Debug: Debug Test" })

dap.configurations.go = {
   {
      type = "go",
      name = "Debug",
      request = "launch",
      showLog = true,
      program = "${file}",
   },
   {
      type = "go",
      name = "Debug Package",
      request = "launch",
      showLog = true,
      program = "${fileDirname}",
   },
   {
      type = "go",
      name = "Debug main.go",
      request = "launch",
      showLog = true,
      program = "${workspaceFolder}/cmd/api/main.go",
   },
   {
      type = "go",
      name = "Attach",
      mode = "local",
      request = "attach",
      processId = require('dap.utils').pick_process,
   },
   {
      type = "go",
      name = "Debug Test (Current File)",
      request = "launch",
      mode = "test",
      showLog = true,
      program = "${file}",
   },
   {
      type = "go",
      name = "Debug Test (Current Package)",
      request = "launch",
      mode = "test",
      showLog = true,
      program = "${fileDirname}",
   },
}
