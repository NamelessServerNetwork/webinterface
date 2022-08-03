debug.setFuncPrefix("[DB]")
dlog("Prepare login DB")

local db, err = env.lib.sqlite.open(env.devConf.userLoginDatabasePath)
local createSysinfoEntry = true

ldlog(db, err)

dlog("Create sysinfo table: " .. tostring(db:exec([[
	CREATE TABLE sysinfo (
		userCount INTEGER NOT NULL
	);
]])))

dlog("Create users table: " .. tostring(db:exec([[
	CREATE TABLE users (
		username TEXT NOT NULL,
		password TEXT NOT NULL,
		id INTEGER NOT NULL
	);
]])))

dlog("Create permissions table: " .. tostring(db:exec([[
	CREATE TABLE permissions (
		userID INTEGER NOT NULL,
		permission TEXT NOT NULL,
		level INTEGER NOT NULL
	);
]])))

dlog("Create sessions table: " .. tostring(db:exec([[
	CREATE TABLE sessions (
		sessionID TEXT NOT NULL,
		token TEXT NOT NULL,
		expireTime INTEGER NOT NULL,
		userID INTEGER NOT NULL
	);
]])))


dlog("Prepare sysinfo table: " .. tostring(env.loginDB:exec([[
	SELECT userCount FROM sysinfo
]], function(udata,cols,values,names)
	for i=1,cols do 
		if names[i] == "userCount" then
			createSysinfoEntry = false
		end
	end
	return 0
end)))

if createSysinfoEntry then
	dlog("Create sysinfo entry: " .. tostring(db:exec([[INSERT INTO sysinfo VALUES (0);]])))
end

db:close()