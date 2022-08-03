env.getThreadInfos = function()
	local _internal = getmetatable(env)._internal
	
	return {
		id = _internal.threadID,
		name = _internal.threadName,
	}
end