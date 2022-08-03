log("--===== SHARED TEST THREAD#1 START ======--")

env.event.listen("STT#1", function()
    log("STT#1_test")

    --log(env.shared.t1.t2)

    --env.shared.t1.t2("unlock")
    

    env.shared.t1.t2 = "NEW VALUE!" --#1
    
    --env.shared.t1.st1 = "first new value"

    --log(env.shared.t1.t2)

    log("New value is set")

    
    env.thread.getChannel("SHARING_TEST_THREAD_WAIT#1"):push(true)
    log("STT#1_test_done")
    --env.event.push("STT#2")
    --env.event.push("SHARING_TEST_STOP")
end)

env.event.listen("SHARING_TEST_STOP", function()
    log("STT#1_stop")
    env.stop()
end)

env.thread.getChannel("SHARING_TEST_THREAD_INIT"):push(1)

log("--===== SHARED TEST THREAD#1 END ======--")
--env.stop()