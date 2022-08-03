return function()
	env.event.ignoreAll()
	getmetatable(env)._internal.threadIsActive = false
end