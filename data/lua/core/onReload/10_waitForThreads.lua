local programActiveChannel = env.thread.getChannel("PROGRAM_IS_RUNNING")

env.getInternal().stopThreads()

programActiveChannel:pop()
programActiveChannel:push(true)