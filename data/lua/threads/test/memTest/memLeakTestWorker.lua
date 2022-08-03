
env.lib.thread.getChannel("MEM_LEAK_TEST_WORKER_DONE"):push(env.getThreadInfos())
--log("Done")
env.stop()
