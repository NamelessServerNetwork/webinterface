package.path = package.path .. ";" .. "/data/dams/data/lua/libs/?.lua;/data/dams/data/lua/libs/thirdParty/?.lua"
package.cpath = package.cpath .. ";" .. "/data/dams/data/bin/libs/?.so"



--local http_headers = require "http.headers"
local cqueues = require("cqueues")
local thread = require("cqueues.thread")
local cq = cqueues.new()

local function sleep(s)
	print("sleep: " .. tostring(s))
	local startTime = os.time()
	while os.time() < startTime + s do end
end

local function threadFunc(con, t, t2)
	local function sleep(s)
		print("sleep: " .. tostring(s))
		local startTime = os.time()
		while os.time() < startTime + s do 
			--print(os.time())
		end
	end
	
	print("START: " .. tostring(t))
	con:write({}, "\n")
	sleep(5)
	print("END")
end


local thr, con = thread.start(threadFunc, "T1", "T2")

--print(thr:join())

--cq:step()


print("WAIT")


sleep(3)

for l in con:lines() do
	print(l)
end


print("TEST END")
