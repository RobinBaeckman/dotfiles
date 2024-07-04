local Task = {}
Task.__index = Task

function Task:new(presented, want, task_type, desc)
   local task = {
      Presented = presented,
      Want = want,
      Type = task_type,
      Desc = desc
   }
   setmetatable(task, Task)
   return task
end

function Task:display()
   return self.Presented
end

function Task:validate(modified)
   return modified == self.Want
end

return Task
