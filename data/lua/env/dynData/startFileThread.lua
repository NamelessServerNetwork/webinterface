local env, shared = ...

return function(dir, name, args)
	local thread, id = env.newFileThread(dir, name, args)
	
	if thread ~= false then
		tdlog("Starting thread: " .. tostring(name) .. " (" .. tostring(thread) .. "): " .. tostring(suc))
		local _, suc = xpcall(thread.start, debug.traceback, thread)
		return suc, thread, id
	else
		warn("Cant start thread: " .. id)
	end
end