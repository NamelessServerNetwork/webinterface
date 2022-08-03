package.path = package.path .. ";" .. "/data/dams/data/lua/libs/?.lua;/data/dams/data/lua/libs/thirdParty/?.lua"
package.cpath = package.cpath .. ";" .. "/data/dams/data/bin/libs/?.so"

--local http_headers = require "http.headers"
local cqueues = require("cqueues")
local thread = require("cqueues.thread")
local cq = cqueues.new()
local cq2 = cqueues.new()

local done1, done2 = false, false
local allDone = false

local con1, con2 

local function sleep(s)
	--print("sleep: " .. tostring(s))
	local startTime = os.time()
	while os.time() < startTime + s do cqueues.sleep() end
end

local function test1()
	print("test1 start")
	sleep(3)
	done1 = true
	print("test1 end")
end
local function test2()
	print("test2 start")
	sleep(3)
	done2 = true
	print("test2 end")
end


cq2:wrap(function()
	print("T")
	con1 = cq:wrap(test1)
	con2 = cq:wrap(test2)
	
	print("T2")
	
	cq:step()
	
	print("T3")
end)
cq2:step()

print("loop")

cq:loop()

print("WAIT")

sleep(1)

print("TEST END")

