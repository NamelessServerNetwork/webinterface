log("--===== SHARED TEST THREAD#2 START ======--")

env.event.listen("STT#2", function()
    log("STT#2_test")

	--env.shared.t1 = "second new value"

	--sleep(.5)
	
	--env.shared.t1.t2

	--log("second new value is set")


	env.thread.getChannel("SHARING_TEST_THREAD_WAIT#2"):push(true)
	log("STT#2_test_done")
	
	--env.event.push("SHARING_TEST_STOP")
end)

env.event.listen("SHARING_TEST_STOP", function()
    log("STT#2_stop")
    env.stop()
end)

env.thread.getChannel("SHARING_TEST_THREAD_INIT"):push(2)

log("--===== SHARED TEST THREAD#2 END ======--")
--env.stop()