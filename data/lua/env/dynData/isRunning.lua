local env = ...

local channel = env.thread.getChannel("PROGRAM_IS_RUNNING")

return function()
	return channel:peek()
end