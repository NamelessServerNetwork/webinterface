dlog("Start")

local workerThreads = 100

local function p(...)
	print(...)
	return ...
end
local function l(...)
	log(...)
	return ...
end
local function wait(channelName)
	local count = 0
	while true do --wait for worker to be done
		env.thread.getChannel(channelName):demand()
		count = count +1
		if count >= workerThreads then break end
	end
end

local db = l(env.sqlite.open("testDB.sqlite3"))

l(db:exec([[
	CREATE TABLE test (
		tv1 TEXT,
		tv2 TEXT,
		tv3 TEXT
	);
]]))


for c = 1, workerThreads do
	env.startFileThread("lua/threads/test/sqlite/sqliteBruteForceWorker.lua", "SQLITE_BRUTEFORCE_WORKER#" .. tostring(c), {waitTime = c})
end

wait("DB_BRUTEFORCE_TEST_WORKERS_INIT_DONE")
dlog("Start brute force")

env.shared.dbbfTestRunning = true

wait("DB_BRUTEFORCE_TEST_WORKERS_DONE")

dlog("DB brute force test done")

env.shared.dbbfTestRunning = false
env.shared.dbbfTestRepeate = true
env.stop()