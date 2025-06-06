# Enhance GMod Lua with a Powerful, Flexible switch Statement!
Tired of messy if-elseif chains? My Lua switch function brings clean, readable, and efficient conditional branching to GMod scripts — supporting multiple operators (==, !=, <, >, in, custom functions, and a default case). It compiles cases for speed and caches them for reusability, making your code easier to maintain and faster to execute.

Integrating this into the core GMod Lua would simplify countless scripts, boost readability, and empower developers to write clearer, more expressive logic effortlessly.

Let’s make GMod Lua coding smarter and more elegant — consider adding this switch construct to the official toolkit!

| Operator   | Description                                   | Example usage                                         |
|------------|-----------------------------------------------|------------------------------------------------------|
| `==`       | Equal to                                     | `{"==", 5, function() print("Value is 5") end}`      |
| `!=`       | Not equal to                                 | `{"!=", 10, function() print("Not 10") end}`         |
| `>`        | Greater than                                 | `{">", 3, function() print("Greater than 3") end}`   |
| `>=`       | Greater than or equal to                      | `{">=", 7, function() print("At least 7") end}`      |
| `<`        | Less than                                    | `{"<", 0, function() print("Negative") end}`         |
| `<=`       | Less than or equal to                         | `{"<=", 100, function() print("100 or less") end}`   |
| `in`       | Belongs to a list                            | `{"in", {1, 2, 3}, function() print("In the list") end}` |
| `func`     | Custom function returning a boolean          | `{"func", function(v) return v % 2 == 0 end, function() print("Even") end}` |
| `default`  | Default case (runs if no other case matches) | `{"default", function() print("Default case") end}`  |
## Quick Start
```lua
local value = 10

switch(value) {
    {"<", 5, function() print("Less than 5") end},
    {"in", {10, 15, 20}, function() print("Value is in the list") end},
    {"default", function() print("No match found") end}
}
```
```txt
Value is in the list
```
## Advanced Example: Handling Player States
Imagine you want to handle different player states with custom logic—like health levels, status effects, or commands—in a clean, maintainable way.
```lua
local function handlePlayerState(player)
    local health = player:Health()
    local status = player:GetNWString("Status") -- Custom networked string

    -- Use switch on health ranges
    switch(health) {
        {">=", 75, function() print("Player is healthy") end},
        {">=", 40, function() print("Player is wounded") end},
        {"<", 40, function() print("Player is critical") end},
        {"default", function() print("Unknown health state") end}
    }

    -- Use switch on player status string
    switch(status) {
        {"==", "poisoned", function() print("Apply poison effect") end},
        {"==", "stunned", function() print("Apply stun effect") end},
        {"in", {"burning", "onfire"}, function() print("Apply burn effect") end},
        {"default", function() print("No special status effects") end}
    }

    -- Example of custom function to detect if player name contains 'admin'
    switch(player:GetName()) {
        {"func", function(name) return string.find(name:lower(), "admin") ~= nil end,
            function() print("Admin privileges granted") end},
        {"default", function() print("Standard player") end}
    }
end

-- Example usage: simulate player states
local mockPlayer = {
    Health = function() return 55 end,
    GetNWString = function(_, key) return key == "Status" and "poisoned" or "" end,
    GetName = function() return "SuperAdmin123" end
}

handlePlayerState(mockPlayer)
```
```txt
Player is wounded
Apply poison effect
Admin privileges granted
```
## Performance: Compilation Speed on Large Case Sets
To demonstrate the efficiency of the switch statement compilation, here’s a benchmark with over 1000 complex cases mixing all supported operators and custom functions:
```lua
local large_cases = {}

for i = 1, 1000 do
    if i % 10 == 0 then
        table.insert(large_cases, {
            "func",
            function(v) return v % i == 0 end,
            function() end
        })
    elseif i % 5 == 0 then
        table.insert(large_cases, {
            "in",
            {i, i+1, i+2},
            function() end
        })
    elseif i % 3 == 0 then
        table.insert(large_cases, {
            ">=",
            i,
            function() end
        })
    else
        table.insert(large_cases, {
            "==",
            i,
            function() end
        })
    end
end

table.insert(large_cases, {
    "default",
    function() end
})

local startTime = os.clock()
local compiledFunc = compile_cases(large_cases)
local endTime = os.clock()

print(string.format("Compilation of large_cases took %.6f seconds", endTime - startTime))
```
```txt
Compilation of large_cases took 0.000226 seconds
```
This shows that even for very large and complex case tables, the compilation remains extremely fast, ensuring your scripts stay performant and responsive.