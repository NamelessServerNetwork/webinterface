local requestChannel = env.thread.getChannel("SHARED_REQUEST")

log("Dumping shared table")
requestChannel:push({
    request = "dump_shared_table",
    threadID = -1,
})