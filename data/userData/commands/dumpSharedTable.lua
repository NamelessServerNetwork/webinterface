env.thread.getChannel("SHARED_REQUEST"):push({
    request = "dump",
    threadID = env.getThreadInfos().id,
})