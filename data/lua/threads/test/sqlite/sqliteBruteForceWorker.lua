--log("INIT")
--===== conf ======--
local insertActions = 1

if env.getThreadInfos().name == "[SQLITE_BRUTEFORCE_WORKER#1]" then
	insertActions = 1
end

--===== local funcs ======--
local function p(...)
	print(...)
	return ...
end
local function l(...)
	log(...)
	return ...
end

function dumpDB(udata,cols,values,names)
	print('exec:')
	for i=1,cols do 
		print('',names[i],values[i]) 
	end
	return 0
end

--===== local vars ======--
local db = env.sqlite.open("testDB.sqlite3")

db:busy_handler(function(_, attempt) 
	if attempt == 0 then
		--dlog("BUSY")
	end
	sleep(env.devConf.sqlite.busyWaitTime)
	--dlog("Attempt: ", attempt)
	
	return 1
end)

--===== prog start ======--
env.thread.getChannel("DB_BRUTEFORCE_TEST_WORKERS_INIT_DONE"):push(env.getThreadInfos().name)
--log("WAIT")
while not env.shared.dbbfTestRunning do sleep(.01) end --wait for test to start
--log("START")

if env.getThreadInfos().name ~= "[SQLITE_BRUTEFORCE_WORKER#1]" then
	sleep(.1)
end


for c = 1, insertActions do
	if true then
		if db:exec([[
			INSERT INTO test VALUES ("]] .. env.getThreadInfos().name .. [[", "]] .. tostring(c) .. [[", NULL);
		]]) == 1 then
			err("WRITE ERROR: ", 1)
		end
	end
	
	if false then
		if db:exec([[
			SELECT rowid, * FROM test
		]], function() return 0 end) == 1 then
			err("READ ERROR: ", 1)
		end
	end
	
end

--===== prog end ======--
db:close()

env.thread.getChannel("DB_BRUTEFORCE_TEST_WORKERS_DONE"):push(env.getThreadInfos().name)

if env.getThreadInfos().name == "[SQLITE_BRUTEFORCE_WORKER#1]" then
	print("##################")
end

log("Done")


env.stop()