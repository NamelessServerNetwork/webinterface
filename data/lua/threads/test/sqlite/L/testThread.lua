local testWorker = loadfile("lua/threads/test/sqlite/L/testWorker.lua")

local suc, err = xpcall(testWorker, debug.traceback)

dlog(suc, err)

env.stop()