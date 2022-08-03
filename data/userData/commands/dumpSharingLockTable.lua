env.thread.getChannel("SHARED_REQUEST"):push({
    request = "dump_lockTable",
    threadID = env.getThreadInfos().id,
})