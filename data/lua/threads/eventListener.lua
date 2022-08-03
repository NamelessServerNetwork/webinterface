--[[
	default enevt DAMS is listening to.
]]

log("Starting event listener")

dlog("Register all listeners")

env.event.listen("STOP_PROGRAM", function(data)
	log("Stopping program")
	env.getInternal().stopThreads()
	require("love.event").quit("Stopped by event")
end)

dlog("Listeners registration done")