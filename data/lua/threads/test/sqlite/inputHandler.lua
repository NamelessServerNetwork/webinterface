--sqlite test input handler

log("Start")

local function bruteforce(task)
	for _, t in pairs(task) do
		if t == "B" then
			env.startFileThread("lua/threads/test/sqlite/sqliteBruteForceManager.lua", "SQLITE_BRUTEFORCE_MANAGER")
		end
	end
end


env.event.listen("sqliteTest1", bruteforce)


for c = 1, 20 do
	env.shared.dbbfTestRepeate = false
	bruteforce()
	while env.shared.dbbfTestRepeate == false do sleep(.1) end
end

dlog("All tests done")