local TaskManager = {}
TaskManager.__index = TaskManager

function TaskManager:new()
   local manager = {
      tasks = {},
      current_task = nil,
      score = 0,
      start_time = os.time(),
      timer_running = true,
      log_file = "/tmp/vim_debug.log",
      game_bufnr = nil
   }
   setmetatable(manager, TaskManager)
   return manager
end

function TaskManager:log_debug(message)
   local file = io.open(self.log_file, "a")
   file:write(message .. "\n")
   file:close()
end

function TaskManager:add_task(task)
   table.insert(self.tasks, task)
end

function TaskManager:select_random_task()
   if #self.tasks == 0 then
      error("No tasks available")
   end
   self.current_task = self.tasks[math.random(#self.tasks)]
   return self.current_task
end

function TaskManager:present_task()
   if not self.current_task then
      error("No task selected")
   end
   return self.current_task:display()
end

function TaskManager:update_task_and_timer()
   local current_time = os.time()
   local elapsed_time = os.difftime(current_time, self.start_time)
   local minutes = math.floor(elapsed_time / 60)
   local seconds = elapsed_time % 60
   local timer_message = string.format("Time: %02d:%02d", minutes, seconds)

   local task_message = "Task: " .. self.current_task.Desc .. " | Score: " .. self.score
   local viewport_width = vim.api.nvim_win_get_width(0)
   local total_message = task_message .. " | " .. timer_message

   if vim.api.nvim_buf_is_valid(self.game_bufnr) then
      vim.api.nvim_buf_set_lines(self.game_bufnr, 0, 1, false, { total_message })
   end

   if self.timer_running then
      vim.defer_fn(function() self:update_task_and_timer() end, 1000)
   end
end

function TaskManager:create_game_buffer()
   -- Create a new buffer for the game
   self.game_bufnr = vim.api.nvim_create_buf(false, true)
   vim.api.nvim_set_current_buf(self.game_bufnr)
   vim.api.nvim_buf_set_option(self.game_bufnr, 'bufhidden', 'wipe')
end

function TaskManager:reset_buffer_with_random_function()
   self:create_game_buffer()

   -- Clear the buffer
   vim.api.nvim_buf_set_lines(self.game_bufnr, 0, -1, false, {})

   -- Get the viewport height dynamically
   local viewport_height = vim.api.nvim_win_get_height(0)

   -- Insert the task's presented function
   local function_lines = {}
   for line in self.current_task.Presented:gmatch("([^\n]*)\n?") do
      table.insert(function_lines, line)
   end
   local func_height = #function_lines

   -- Calculate the number of blank lines needed
   local blank_lines_count = viewport_height - func_height - 1 -- Additional line for task and timer

   -- Ensure the buffer has exactly viewport_height lines
   local buffer_lines = {}
   table.insert(buffer_lines, "") -- Placeholder for the task and timer message
   for _ = 1, blank_lines_count do
      table.insert(buffer_lines, "")
   end

   -- Insert the function lines at a random position within the viewport
   local insert_line = math.random(2, blank_lines_count + 1)
   for i = 1, #function_lines do
      table.insert(buffer_lines, insert_line + i - 1, function_lines[i])
   end

   -- Store the insert line and function height for validation
   self.current_task.insert_line = insert_line
   self.current_task.func_height = func_height

   -- Set the buffer lines
   vim.api.nvim_buf_set_lines(self.game_bufnr, 0, -1, false, buffer_lines)

   -- Move cursor to a random line within the viewport that doesn't exceed the function length
   local cursor_line = math.random(2, blank_lines_count + 1)
   vim.api.nvim_win_set_cursor(0, { cursor_line, 0 }) -- Line numbers in API start from 1

   -- Start the timer
   self:update_task_and_timer()
end

-- Function to normalize content by trimming extra spaces and newlines
function TaskManager:normalize_content(content)
   return content:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", ""):gsub("\n", " ")
end

function TaskManager:get_current_content()
   local buf_lines = vim.api.nvim_buf_get_lines(self.game_bufnr, 1, -1, false) -- Skip the first line
   return table.concat(buf_lines, "\n")
end

function TaskManager:get_register_content()
   return vim.fn.getreg('"')
end

function TaskManager:validate_task()
   if not self.current_task then
      error("No task selected")
   end

   local got_content
   if self.current_task.Action == "yank" then
      got_content = self:get_register_content()
   else
      got_content = self:get_current_content()
   end

   -- Normalize both current and expected content
   local normalized_got_content = self:normalize_content(got_content)
   local normalized_expected_content = self:normalize_content(self.current_task.Want)

   self:log_debug("Got: " .. normalized_got_content)
   self:log_debug("Want: " .. normalized_expected_content)

   return normalized_got_content == normalized_expected_content
end

function TaskManager:on_lines()
   self:log_debug("Checking task completion...")
   vim.defer_fn(function()
      if self.current_task then
         local completed = self:validate_task()
         if completed then
            self.score = self.score + 1
            self:log_debug(string.format("Well done! Your score is now: %d", self.score))
            self:log_debug("Task completed successfully.")
            self:start_game() -- Restart the game
         else
            self:log_debug("Task not completed correctly.")
            self:log_debug("Got: " .. self:normalize_content(self:get_current_content()))
            self:log_debug("Want: " .. self:normalize_content(self.current_task.Want))
         end
      end
   end, 200) -- Delay by 200 milliseconds to ensure the buffer is updated
end

function TaskManager:disable_linter(bufnr)
   vim.api.nvim_buf_set_option(bufnr, 'filetype', 'text')
end

function TaskManager:start_game()
   self:log_debug("Starting new task...")
   self:select_random_task()
   self:reset_buffer_with_random_function()

   self:disable_linter(self.game_bufnr)

   vim.api.nvim_clear_autocmds({ buffer = self.game_bufnr, event = { "TextChanged", "TextChangedI", "BufWritePost" } })
   vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost" }, {
      callback = function()
         vim.schedule(function() self:on_lines() end)
      end,
      buffer = self.game_bufnr,
   })
end

return TaskManager
