-- load libs
local thread = require("love.thread")
local timer = require("love.timer")
local ut = require("UT")

-- conf
local threadAmount = 10000

-- local funcs
local function errLog(...) --prints all parameters if the first one is not true. returns all values.
    local t = {...}
    if t[1] ~= true then
        io.write("ERR: ")
        print(...)
    end
    return ...
end

-- test start
print("TEST START")

for c = 1, threadAmount do
    local thr = {thread.newThread("\n return")}	
    if errLog(thr[1]:start()) ~= true then 
        print("Count not start thread: #" .. tostring(c))
        print(ut.tostring(thr))        
        break
    end
	thr[1]:wait()
end

print("TEST DONE")