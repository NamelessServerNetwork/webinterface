local env, shared = ...

local idChannel = env.thread.getChannel("GET_THREAD_ID")
local threadRegistrationChannel = env.thread.getChannel("THREAD_REGISTRATION")

return function(dir, name, args)
	ldlog("Load thread " .. name .. " from file: " .. dir)

	if type(name) == "string" then name = "[" .. name .. "]" end
	local suc, file = pcall(io.open, "data/" .. dir, "r")
	local threadID, threadCode

	if type(file) == "userdata" then
		local thread

		threadID = idChannel:push(name); idChannel:pop()
		threadCode = env.getThreadInitCode(file:read("*all"), {name = name, id = threadID, args = args})
		file:close()

		thread = env.thread.newThread(threadCode)
		
		threadRegistrationChannel:push({
			thread = thread,
			name = name,
			id = threadID,
		})
		
		return thread, threadID
	else
		warn("Cant load thread from file: (" .. dir .. ")")
		return false, "File not found"
	end
end