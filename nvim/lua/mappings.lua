-- Function to execute the current line in Lua
local function exec_current_line()
   local line = vim.api.nvim_get_current_line()
   vim.cmd("lua " .. line)
end

-- Function to execute the visual selection in Lua
local function exec_visual_selection()
   local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
   local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))

   -- Get the text of the visual selection
   local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
   if #lines == 0 then
      return
   end

   -- Adjust the first and last line if necessary
   lines[1] = string.sub(lines[1], start_col)
   if #lines == 1 then
      lines[1] = string.sub(lines[1], 1, end_col - start_col + 1)
   else
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
   end

   -- Concatenate the lines into a single command
   local command = table.concat(lines, "\n")
   vim.cmd("lua " .. command)
end

-- Function to print the visual selection in Lua
local function print_visual_selection()
   local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
   local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))

   -- Get the text of the visual selection
   local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
   if #lines == 0 then
      return
   end

   -- Adjust the first and last line if necessary
   lines[1] = string.sub(lines[1], start_col)
   if #lines == 1 then
      lines[1] = string.sub(lines[1], 1, end_col - start_col + 1)
   else
      lines[#lines] = string.sub(lines[#lines], 1, end_col)
   end

   -- Concatenate the lines into a single command
   local command = table.concat(lines, "\n")
   vim.cmd("lua print(" .. command .. ")")
end

-- Function to print the current line in Lua
local function print_current_line()
   local line = vim.api.nvim_get_current_line()
   vim.cmd("lua print(" .. line .. ")")
end

-- Key mappings
vim.keymap.set('n', '<leader>x', exec_current_line, { noremap = true, silent = true, desc = "Execute the current line" })
vim.keymap.set('v', '<leader>x', exec_visual_selection,
   { noremap = true, silent = true, desc = "Execute the visual selection" })
vim.keymap.set('v', '<leader>p', print_visual_selection,
   { noremap = true, silent = true, desc = "Print the visual selection" })
vim.keymap.set('n', '<leader>p', print_current_line, { noremap = true, silent = true, desc = "Print the current line" })

-- Set the keybinding for executing the current file in normal mode
vim.keymap.set('n', '<leader><leader>x', '<cmd>luafile %<CR>',
   { noremap = true, silent = true, desc = 'Execute the current file' })

-- Keybinding to run tests and log output
-- vim.keymap.set('n', '<leader>t', ':lua RunTestsAndLog()<CR>',
--    { noremap = true, silent = true, desc = "Test: Run tests and log output" })

vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>', { desc = 'Execute the current file' })

-- ======================================
-- Custom Mappings
-- ======================================

-- General custom mappings
-- vim.keymap.set('n', ';', ':', { noremap = true, silent = true, desc = "Command: Enter command mode" })
vim.keymap.set('i', 'jk', '<ESC>', { noremap = true, silent = true, desc = "General: Exit insert mode" })
vim.keymap.set('n', 'q', ':bd<CR>', { noremap = true, silent = true, desc = 'Buffers: Kill current buffer' })

-- Function to handle j and k with count
local function handle_jk_with_count(key)
   return function()
      local count = vim.v.count
      if count > 0 then
         vim.cmd('normal! ' .. count .. key)
      end
   end
end

-- Function to echo message only in normal mode
local function echo_in_normal_mode(message)
   if vim.fn.mode() == 'n' then
      vim.cmd('echo "' .. message .. '"')
   end
end

-- Disable hjkl to encourage efficient movements
vim.keymap.set('n', 'h', function() echo_in_normal_mode("Use more efficient movements!") end,
   { noremap = true, silent = true, desc = "Disable: Left movement" })
vim.keymap.set('n', 'j', handle_jk_with_count('j'), { noremap = true, silent = true, desc = "Disable: Down movement" })
vim.keymap.set('n', 'k', handle_jk_with_count('k'), { noremap = true, silent = true, desc = "Disable: Up movement" })
vim.keymap.set('n', 'l', function() echo_in_normal_mode("Use more efficient movements!") end,
   { noremap = true, silent = true, desc = "Disable: Right movement" })

-- ======================================
-- Disable Existing Mappings
-- ======================================

-- Disable existing Tab and Shift+Tab mappings
vim.keymap.set('n', '<tab>', '<Nop>', { noremap = true, silent = true, desc = "General: Disable <tab>" })
vim.keymap.set('n', '<S-tab>', '<Nop>', { noremap = true, silent = true, desc = "General: Disable <S-tab>" })

-- ======================================
-- Register Mappings
-- ======================================

-- Save all deletions and copies to the 'a' register
vim.keymap.set('n', '@', '"ap', { noremap = true, silent = true, desc = "Register: Paste from register a" })
vim.keymap.set('x', 'p', '"adP', { noremap = true, silent = true, desc = "Register: Paste and delete to register a" })
vim.keymap.set('n', 'd', '"ad', { noremap = true, silent = true, desc = "Register: Delete to register a" })
vim.keymap.set('v', 'd', '"ad', { noremap = true, silent = true, desc = "Register: Delete to register a" })
vim.keymap.set('n', 'D', '"aD', { noremap = true, silent = true, desc = "Register: Delete line to register a" })
vim.keymap.set('v', 'D', '"aD', { noremap = true, silent = true, desc = "Register: Delete line to register a" })
vim.keymap.set('n', 'c', '"ac', { noremap = true, silent = true, desc = "Register: Change to register a" })
vim.keymap.set('v', 'c', '"ac', { noremap = true, silent = true, desc = "Register: Change to register a" })
vim.keymap.set('n', 'C', '"aC', { noremap = true, silent = true, desc = "Register: Change line to register a" })
vim.keymap.set('v', 'C', '"aC', { noremap = true, silent = true, desc = "Register: Change line to register a" })
vim.keymap.set('n', 'x', '"ax', { noremap = true, silent = true, desc = "Register: Cut to register a" })
vim.keymap.set('v', 'x', '"ax', { noremap = true, silent = true, desc = "Register: Cut to register a" })
vim.keymap.set('n', 'X', '"aX', { noremap = true, silent = true, desc = "Register: Cut line to register a" })
vim.keymap.set('v', 'X', '"aX', { noremap = true, silent = true, desc = "Register: Cut line to register a" })

-- ======================================
-- Tmux Pane Resizing
-- ======================================

-- Resize with Alt+Shift key combinations
vim.keymap.set('n', '<M-l>', ':vertical resize -2<CR>',
   { noremap = true, silent = true, desc = "Tmux: Resize pane left" })
vim.keymap.set('n', '<M-h>', ':vertical resize +2<CR>',
   { noremap = true, silent = true, desc = "Tmux: Resize pane right" })
vim.keymap.set('n', '<M-k>', ':resize -2<CR>', { noremap = true, silent = true, desc = "Tmux: Resize pane up" })
vim.keymap.set('n', '<M-j>', ':resize +2<CR>', { noremap = true, silent = true, desc = "Tmux: Resize pane down" })

-- ======================================
-- Tmux Pane Splitting
-- ======================================

-- Vertical and Horizontal splits
-- vim.keymap.set('n', '<leader>sh', ':silent !tmux split-window -v<CR>',
--    { noremap = true, silent = true, desc = "Tmux: Split pane vertically" })
-- vim.keymap.set('n', '<leader>sv', ':silent !tmux split-window -h<CR>',
--    { noremap = true, silent = true, desc = "Tmux: Split pane horizontally" })

-- ======================================
-- Search Highlight Clearing
-- ======================================

-- Clear search highlight
vim.keymap.set('n', '<leader><space>', ':noh<CR>',
   { noremap = true, silent = true, desc = "Search: Clear search highlight" })

-- ======================================
-- Go Playground Mapping
-- ======================================

-- Map <leader>gp to the OpenGoPlayground function
vim.keymap.set('n', '<leader>gp', ':lua OpenGoPlayground()<CR>',
   { noremap = true, silent = true, desc = "Go: Open Go Playground" })

-- Function to open a Go playground
function OpenGoPlayground()
   local playground_dir = vim.fn.expand("~/go-workspace/playground/")
   local timestamp = os.date("%Y%m%d%H%M%S")
   local file_name = timestamp .. "_test.go"
   local file_path = playground_dir .. file_name

   -- Unique package and function names
   local package_name = "test" .. timestamp
   local function_name = "test" .. timestamp

   -- Initial content of the Go file
   local initial_content = string.format([[
package %s

import "fmt"

func %s() {
    fmt.Println("Hello, playground")
}
]], package_name, function_name)

   -- Create the file and write the initial content
   local file = io.open(file_path, "w")
   if file then
      -- Write the initial content to the file
      file:write(initial_content)
      -- Close the file
      file:close()
   else
      -- Print an error message if the file could not be created
      print("Could not create file: " .. file_path)
      return
   end

   -- Open the newly created file in Vim
   vim.cmd('edit ' .. file_path)
end

-- ======================================
-- Scrolling Enhancements
-- ======================================

vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true, desc = "Scroll: Half-page down and center" })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true, desc = "Scroll: Half-page up and center" })

-- ======================================
-- Bookmark Picker
-- ======================================

-- Set a keybinding to open the bookmark picker with description
vim.keymap.set("n", "<Leader>bl", ":lua _G.list_bookmarks()<CR>",
   { noremap = true, silent = true, desc = "Bookmarks: Open bookmark picker" })


-- Key Mapping for Theme Switching
vim.keymap.set('n', '<leader>th', function()
   require('utils.telescope_themes').themes()
end, { desc = 'Switch Theme' })

-- Define a variable to store the window layout
local window_layout = nil

-- Function to toggle fullscreen
function _G.toggle_fullscreen()
   if window_layout == nil then
      -- Save the current window layout
      window_layout = vim.fn.winrestcmd()
      -- Maximize the current window
      vim.cmd('wincmd _')
      vim.cmd('wincmd |')
   else
      -- Restore the saved window layout
      vim.cmd(window_layout)
      window_layout = nil
   end
end

-- Key mapping to toggle fullscreen
vim.api.nvim_set_keymap('n', '<leader>z', ':lua toggle_fullscreen()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>b', ':b#<CR>', { noremap = true, silent = true })
