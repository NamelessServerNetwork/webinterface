log("Starting thread manager")

local threadRegistrationChannel = env.thread.getChannel("THREAD_REGISTRATION")
local activeThreadsChannel = env.thread.getChannel("ACTIVE_THREADS")

local function newThread(thread) 
	if thread ~= nil then
		tdlog("Registering new thread (".. tostring(thread.id) .."): " .. env.ut.parseArgs(thread.name, "UNKNOWN") .. "(" .. tostring(thread.thread) .. ")")
		
		activeThreadsChannel:push(thread)
	end
end

local function update()
	newThread(threadRegistrationChannel:demand(1))
end