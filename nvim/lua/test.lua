-- Define some variables
local a = 10
local b = 20
local c = 30

-- Define a function to add two numbers
local function add(x, y)
   return x + y
end

-- Define a function to multiply two numbers
local function multiply(x, y)
   return x * y
end

-- Define a function to perform a complex calculation
local function complex_calculation(x, y, z)
   local sum = add(x, y)
   local product = multiply(sum, z)
   return product
end

-- Main program
local result = complex_calculation(a, b, c)
print("The result of the complex calculation is: " .. result)

