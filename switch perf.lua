-- lua local switch = require("switch")
-- glua local switch = include("switchfile.lua")

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

compiledFunc(500)
