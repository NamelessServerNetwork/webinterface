dlog("Start")

local workerThreads = 100000

local confirmChannelName = "MEM_LEAK_TEST_WORKER_DONE"

local function p(...)
	print(...)
	return ...
end
local function l(...)
	log(...)
	return ...
end
local function wait(channelName)
	local count = 0
	while true do --wait for worker to be done
		env.lib.thread.getChannel(channelName):demand()
		count = count +1
		if count >= workerThreads then break end
	end
end
local function startThreads()
	for c = 1, workerThreads do
		local suc, thread, id, errMsg, errMsg2 = env.dyn.startFileThread("lua/threads/test/memTest/memLeakTestWorker.lua", "MEM_LEAK_TEST_WORKER#" .. tostring(c))
		
		thread:wait()
		
		if suc ~= true then
			err("Thread could not start")
			err(suc)
			err(errMsg)
			
			dlog(thread)
			dlog(thread:start())
			dlog(thread:isRunning())
			dlog(thread:getError())
			
			return false
		end
	end
	return true
end

--===== prog start =====--
dlog("Start test")

--[[
for c = 0, 30 do
	dlog("Start test #" .. tostring(c))
	if not startThreads() then
		err("Could not complete test.")
		env.stop()
	end
	dlog("Wait for workers")
	wait(confirmChannelName)
	dlog("Test done #" .. tostring(c))
end
]]


if not startThreads() then
	err("Could not complete test.")
	env.stop()
end


--[[
local threads = {}
for c = 1, 1000 do
	local thread = env.lib.thread.newThread("lua/threads/test/memTest/testThread.lua")
	if thread:start() ~= true then
		err("Could not start thread")
		break
	end
end
]]




--===== prog end =====--

dlog("Wait for workers do be done")
--wait(confirmChannelName)
dlog("All tests done")


env.stop()