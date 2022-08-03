local env, shared = ...

log("Start test threads")

--env.startFileThread("lua/threads/test/terminalTestThread1.lua", "TerminalTestThread#1")
--[[

log("Waiting for old test threads to stop")
local testThreadsActiveChannel = env.thread.getChannel("TEST_THREAD_ACTIVE")
if env.oldEnv ~= nil and env.oldEnv.testThreads ~= nil then
	testThreadsActiveChannel:pop()
	testThreadsActiveChannel:push(false)
	
	for i, thread in pairs(env.oldEnv.testThreads) do
		thread:wait()
	end
end

log("Starting test threads")
testThreadsActiveChannel:pop()
testThreadsActiveChannel:push(true)

env.testThreads = {}

table.insert(env.testThreads, select(2, env.startFileThread("lua/threads/shared/sharedMain.lua", "SharingManagerThread")))

table.insert(env.testThreads, select(2, env.startFileThread("lua/threads/test/shared/sharedTestThread1.lua", "SharedTestThread#1")))
table.insert(env.testThreads, select(2, env.startFileThread("lua/threads/test/shared/sharedTestThread2.lua", "SharedTestThread#2")))
table.insert(env.testThreads, select(2, env.startFileThread("lua/threads/test/shared/sharedControlThread.lua", "SharedControlThread")))

]]

--env.startFileThread("lua/threads/test/shared/sharedTestThread1.lua", "SharedTestThread#1")
--env.startFileThread("lua/threads/test/shared/sharedTestThread2.lua", "SharedTestThread#2")
--env.startFileThread("lua/threads/test/shared/sharedControlThread.lua", "SharedControlThread")

--env.startFileThread("lua/threads/test/event/eventTestThread1.lua", "EventTestThread#1")
--env.startFileThread("lua/threads/test/event/eventTestThread2.lua", "EventTestThread#2")
--env.startFileThread("lua/threads/test/event/eventControllThread.lua", "eventControllThread#2")

--env.startFileThread("lua/threads/test/http/httpTest.lua", "HTTPTest")

--env.startFileThread("lua/threads/test/printLoop.lua", "PrintLoop")

--env.startFileThread("lua/threads/test/corr.lua", "CORRUPTION_TEST_THREAD")

--env.startFileThread("lua/threads/test/argTest.lua", "argTest", {t1 = "T!"})

--env.startFileThread("lua/threads/test/sqlite/inputHandler.lua", "SQLITE_BRUTEFORCE_INPUT_HANDLER")

--env.startFileThread("lua/threads/test/memTest/inputHandler.lua", "MEM_LEAK_TEST_INPUT_HANDLER")



