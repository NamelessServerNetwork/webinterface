log("--===== TEST EVENT LISTENER THREAD START ======--")

env.event.listen("sharedTest", function()
	log("--=== Shared test ===--")
	
	--restart sharing manager 
	env.thread.getChannel("SHARED_REQUEST"):push({
		request = "stop",
		threadID = env.getThreadInfos().id,
	})
	env.startFileThread("lua/threads/sharingManager.lua", "SHARING_MANAGER")

	--reload shared
	loadfile("lua/env/init/30_tShared.lua")(env)

	--start sharing test threads
	env.startFileThread("lua/threads/test/shared/sharedTestThread1.lua", "SHARING_TEST_THREAD#1")
	env.startFileThread("lua/threads/test/shared/sharedTestThread2.lua", "SHARING_TEST_THREAD#2")

	--start shared test
	loadfile("lua/test/sharedTest.lua")(env)
	
end)

env.event.listen("userTest", function(...)
	for _, a in pairs({...}) do
		print(a)
	end

	loadfile("lua/test/userTest.lua")(env)
end)

while env.isRunning() and false do
	--print(shared.testVal1)
	sleep(1)
end

log("--===== TEST EVENT LISTENER THREAD DONE ======--")