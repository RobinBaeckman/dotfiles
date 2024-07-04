local Task = require('skills.task')
local TaskManager = require('skills.task_manager')

local M = {}

local manager = TaskManager:new()

function M.setup()
   -- Add tasks using multi-line strings

   -- Delete the entire function
   manager:add_task(Task:new(
      [[
func add(a int, b int) int {
    return a + b
}
        ]],
      [[
        ]],
      "delete",
      "Delete the entire 'add' function"
   ))

   -- Delete the function contents
   manager:add_task(Task:new(
      [[
func subtract(a int, b int) int {
    return a - b
}
        ]],
      [[
func subtract(a int, b int) int {
}
        ]],
      "delete",
      "Delete the contents of the 'subtract' function, but keep the function signature"
   ))

   -- Delete function parameters
   manager:add_task(Task:new(
      [[
func multiply(a int, b int) int {
    return a * b
}
        ]],
      [[
func multiply() int {
    return a * b
}
        ]],
      "delete",
      "Delete the parameters of the 'multiply' function, but keep the function body"
   ))

   -- Delete function return statement
   manager:add_task(Task:new(
      [[
func divide(a int, b int) (int, error) {
    if b == 0 {
        return 0, fmt.Errorf("division by zero")
    }
    return a / b, nil
}
        ]],
      [[
func divide(a int, b int) (int, error) {
    if b == 0 {
        return 0, fmt.Errorf("division by zero")
    }
}
        ]],
      "delete",
      "Delete the return statement in the 'divide' function"
   ))

   -- Change a specific line within a function
   manager:add_task(Task:new(
      [[
func printHello() {
    fmt.Println("Hello, World!")
    fmt.Println("Goodbye, World!")
}
        ]],
      [[
func printHello() {
    fmt.Println("Hi, Universe!")
    fmt.Println("Goodbye, World!")
}
        ]],
      "change",
      "Change the first print statement in the 'printHello' function to 'fmt.Println(\"Hi, Universe!\")'"
   ))

   -- Yank a function
   manager:add_task(Task:new(
      [[
func copyMe(a int, b int) int {
    return a + b
}
        ]],
      [[
func copyMe(a int, b int) int {
    return a + b
}
        ]],
      "yank",
      "Yank the entire 'copyMe' function"
   ))
end

function M.start_game()
   manager:start_game()
end

return M
