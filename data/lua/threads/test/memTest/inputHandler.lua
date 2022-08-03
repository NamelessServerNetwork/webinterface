--mem leak test input handler

log("Start")

local function bruteforce()
	env.dyn.startFileThread("lua/threads/test/memTest/memLeakTestManager.lua", "MEM_LEAK_TEST_MANAGER")
end


env.event.listen("sqliteTest1", bruteforce)
