local switch_cache = {}

local valid_ops = {
    ["=="] = true, ["!="] = true, [">"] = true, [">="] = true,
    ["<"] = true, ["<="] = true, ["in"] = true, ["func"] = true, ["default"] = true
}

local function compile_cases(cases)
    local compiled = {}
    local default_action = nil

    for i, caseEntry in ipairs(cases) do
        local op = caseEntry[1]
        if not valid_ops[op] then
            error("Unknown operator in cases[" .. i .. "]: " .. tostring(op) ..
                  ". Valid operators: ==, !=, >, >=, <, <=, in, func, default")
        end

        if op == "default" then
            if default_action then
                error("Multiple 'default' cases found")
            end
            default_action = caseEntry[2]
            if type(default_action) ~= "function" then
                error("'default' action must be a function")
            end
        else
            local cmpVal, action = caseEntry[2], caseEntry[3]
            if type(action) ~= "function" then
                error("Action for operator '" .. op .. "' must be a function")
            end
            table.insert(compiled, {op = op, cmpVal = cmpVal, action = action})
        end
    end

    return function(value)
        for _, c in ipairs(compiled) do
            local condition = false
            local op, cmpVal, action = c.op, c.cmpVal, c.action

            if op == "==" then
                condition = value == cmpVal
            elseif op == "!=" then
                condition = value ~= cmpVal
            elseif op == ">" then
                condition = value > cmpVal
            elseif op == ">=" then
                condition = value >= cmpVal
            elseif op == "<" then
                condition = value < cmpVal
            elseif op == "<=" then
                condition = value <= cmpVal
            elseif op == "in" then
                for _, v in ipairs(cmpVal) do
                    if value == v then
                        condition = true
                        break
                    end
                end
            elseif op == "func" then
                condition = cmpVal(value)
            end

            if condition then
                return action(value)
            end
        end

        if default_action then
            return default_action(value)
        end
    end
end

local function switch(value)
    return function(cases)
        local cached = switch_cache[cases]
        if not cached then
            cached = compile_cases(cases)
            switch_cache[cases] = cached
        end
        return cached(value)
    end
end


return switch