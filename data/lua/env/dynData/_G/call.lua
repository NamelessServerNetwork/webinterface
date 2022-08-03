return function(func, ...)
	local rvalues = {xpcall(func, debug.traceback, ...)}
	local suc = rvalues[1]
	if not suc then
		warn("Failed to call function: " .. tostring(func) .. "; args: " .. env.lib.ut.tostring({...}) .. "\n " .. rvalues[2])
	end
	return suc, rvalues
end