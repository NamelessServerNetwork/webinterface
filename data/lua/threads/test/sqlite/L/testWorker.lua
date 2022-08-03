debug.setFuncPrefix("[WORKER]")

--===== global variables =====--
db = nil

--===== local variables =====--
local conf = {
	dbPath = "data/lua/threads/test/sqlite/L/testDB.sqlite3",
	
	tests = {
		createTable = true,
		addToTable = false,
		readFromTable = false,
		
		test1 = false,
		test2 = false,
	},
}

local dyn = {}

--===== init =====--
log("--===== TEST START =====--")
env.dl.load({
	dir = "lua/threads/test/sqlite/L/dynData", 
	target = _G, 
	name = "sqlite test dyn",
})

db, err = env.lib.sqlite.open(conf.dbPath)
dlog(db, err)

--===== local functions =====--

--===== test start =====--
for test, exec in pairs(conf.tests) do
	if exec then
		log("Executed sqlite test: " .. tostring(test) .. ": " .. env.lib.ut.tostring({loadfile("lua/threads/test/sqlite/L/tests/" .. tostring(test) .. ".lua")(conf, dyn)}))
	end
end

--===== test end =====--
db:close()
