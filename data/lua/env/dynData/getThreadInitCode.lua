local env = ...

--local serialize = require("ser")

return function(code, initData)
	local initData = env.ut.parseArgs(initData, {})
	initData.mainThread = false
	
	local newCode = [[
		local env, shared = loadfile('data/lua/env/envInit.lua')(]] .. env.serialization.line(initData) .. [[); ]] .. code .. [[
		
		do
			local suc, err = xpcall(function()	
				if type(update) == 'function' then --main while (incl. event handler)
					while env.isRunning() and env.threadIsRunning() do
						local suc, err
						
						env.event.pull()
						
						suc, err = xpcall(update, debug.traceback)
						
						if suc ~= true then
							debug.err(suc, err)
						end
					end
				else --only event handler
					while env.isRunning() and env.threadIsRunning() do
						env.event.pull(1)
					end
				end
				
				do --on program stop
					if type(stop) == "function" then
						local suc, err = xpcall(stop, debug.traceback)
						
						if suc ~= true then
							debug.err(suc, err)
						end
					end
				end
				
			end, debug.traceback)
			if suc ~= true then
				debug.setLogPrefix("[INTERNAL_ERROR]" .. debug.getLogPrefix())
				debug.fatal(suc, err)
			end
		end


		
	]]
	
	return newCode
end