-- ======================================
-- Test and Log Output
-- ======================================

-- Keybinding to run tests and log output
-- vim.keymap.set('n', '<leader>t', ':lua RunTestsAndLog()<CR>',
--    { noremap = true, silent = true, desc = "Test: Run tests and log output" })


-- ======================================
-- Tmux Pane Management Functions
-- ======================================

-- Function to check if a tmux pane exists
local function tmux_pane_exists(pane_index)
   vim.fn.system(string.format('tmux list-panes -F "#{pane_index}" | grep -w %s', pane_index))
   return vim.v.shell_error == 0
end

-- Function to wait for a tmux pane to exist with a timeout
local function wait_for_pane(pane_index, timeout)
   local waited = 0
   local interval = 50
   while not tmux_pane_exists(pane_index) and waited < timeout do
      vim.fn.system(string.format('sleep %d', interval))
      waited = waited + interval
   end
   return tmux_pane_exists(pane_index)
end

-- Function to run tests and log output
function RunTestsAndLog()
   -- Get the current file's directory
   local file_path = vim.fn.expand('%:p')
   local dir = vim.fn.fnamemodify(file_path, ':h')

   -- Set the log file path based on the directory
   local log_file = dir .. '/test.log'

   -- Commands to run tests and log output
   local test_cmd = string.format('cd %s && go test ./...', dir)
   local logviewer_cmd = string.format('cd %s && (rm -f %s && touch %s && cat %s; tail -f %s) | logviewer -a -f', dir,
      log_file, log_file, log_file, log_file)

   -- Ensure pane 2 exists, create it if not
   if not tmux_pane_exists(2) then
      vim.fn.system('tmux split-window -h -t 1 "zsh"')
      if not wait_for_pane(2, 2000) then
         print("Failed to create pane 2")
         return
      end
   end

   -- Ensure pane 3 exists, create it if not
   if not tmux_pane_exists(3) then
      vim.fn.system('tmux split-window -v -t 2 "zsh"')
      if not wait_for_pane(3, 2000) then
         print("Failed to create pane 3")
         return
      end
   end

   -- Stop the existing logviewer process in pane 3
   vim.fn.system('tmux send-keys -t 3 C-c')
   vim.fn.system('tmux send-keys -t 3 C-c')

   -- Start the logviewer in pane 3
   vim.fn.system(string.format('tmux send-keys -t 3 "%s" C-m', logviewer_cmd))

   -- Wait a bit to ensure the logviewer has started before running tests
   vim.defer_fn(function()
      -- Ensure tmux pane 2 is in a clean state by sending Ctrl-C twice
      vim.fn.system('tmux send-keys -t 2 C-c')
      vim.fn.system('tmux send-keys -t 2 C-c')

      -- Send the command to run tests to tmux pane 2
      vim.fn.system(string.format('tmux send-keys -t 2 "%s" C-m', test_cmd))
   end, 1000) -- Adjust this delay as necessary
end
