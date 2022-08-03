local env = ...

return function()
	return getmetatable(env)._internal.threadIsActive
end