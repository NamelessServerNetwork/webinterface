local testThread = {
	isRunning = function() return false end, --crash prevention.
}

env.event.listen("sqliteTest1", function(task)
	for _, t in pairs(task) do
		if t == "L" then
			if testThread:isRunning() then
				dlog("Wait for previous test thread to stop")
				testThread:wait()
			end
			_, testThread = env.startFileThread("lua/threads/test/sqlite/L/testThread.lua", "SQLITE_TEST")
		end
	end
end)
