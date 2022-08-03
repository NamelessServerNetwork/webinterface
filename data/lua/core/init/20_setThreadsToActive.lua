local env = ...

local programActiveChannel = env.thread.getChannel("PROGRAM_IS_RUNNING")

programActiveChannel:pop()
programActiveChannel:push(true)