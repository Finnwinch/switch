-- lua local switch = require("switch")
-- glua local switch = include("switchfile.lua")
local function test_numeric()
    local called = nil

    switch(5) {
        {"==", 5, function() called = "eq5" end},
        {"default", function() called = "default" end}
    }
    assert(called == "eq5")

    switch(7) {
        {"!=", 5, function() called = "not5" end},
        {"default", function() called = "default" end}
    }
    assert(called == "not5")

    switch(10) {
        {"<", 5, function() called = "lt5" end},
        {">=", 10, function() called = "gte10" end},
        {"default", function() called = "default" end}
    }
    assert(called == "gte10")

    switch(8) {
        {"func", function(v) return v >= 5 and v <= 10 end, function() called = "range" end},
        {"default", function() called = "default" end}
    }
    assert(called == "range")

    switch(3) {
        {"in", {2, 3, 5}, function() called = "or_test" end},
        {"default", function() called = "default" end}
    }
    assert(called == "or_test")

    switch(7) {
        {"func", function(v) return v >= 5 and v <= 10 and (v == 7 or v == 8) end, function() called = "complex_match" end},
        {"default", function() called = "default" end}
    }
    assert(called == "complex_match")

    switch(11) {
        {"func", function(v) return v >= 5 and v <= 10 and (v == 7 or v == 8) end, function() called = "complex_no_match" end},
        {"default", function() called = "default" end}
    }
    assert(called == "default")
end

local function test_strings()
    local called = nil

    switch("bonjour") {
        {"func", function(v) return v == "salut" or v == "bonjour" end, function() called = "salutations" end},
        {"default", function() called = "default" end}
    }
    assert(called == "salutations")

    switch("hello") {
        {"func", function(v) return v ~= "salut" and v ~= "bonjour" end, function() called = "not_french_greeting" end},
        {"default", function() called = "default" end}
    }
    assert(called == "not_french_greeting")

    switch("coucou") {
        {"==", "coucou", function() called = "coucou" end},
        {"default", function() called = "default" end}
    }
    assert(called == "coucou")

    switch("hey") {
        {"==", "hey", function() called = "hey" end}
    }
    assert(called == "hey")
end

local function test_direct()
    local called = nil

    switch(42) {
        {"==", 42, function() called = "exact_num" end},
        {"default", function() called = "default" end}
    }
    assert(called == "exact_num")

    switch("direct") {
        {"==", "direct", function() called = "exact_str" end},
        {"default", function() called = "default" end}
    }
    assert(called == "exact_str")
end

local function test_default()
    local called = nil

    switch(99) {
        {"==", 1, function() called = "should_not_match" end},
        {"default", function() called = "default_triggered" end}
    }
    assert(called == "default_triggered")
end

local function test_order()
    local called = nil

    switch(5) {
        {">", 2, function() called = "first_match" end},
        {"==", 5, function() called = "second_match" end},
        {"default", function() called = "default" end}
    }
    assert(called == "first_match")
end

test_numeric()
test_strings()
test_direct()
test_default()
test_order()