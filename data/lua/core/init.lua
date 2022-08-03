local version, args = ...

--===== parse args/defConf =====--
local args = loadfile("data/lua/core/parseArgs.lua")(args, version) --parse args

--===== pre initialisation =====--

local devConf = loadfile("data/devConf.lua")()
local logfile = loadfile("data/lua/core/initLogfile.lua")(devConf, args)

local env, shared = loadfile("data/lua/env/envInit.lua")({name = "[MAIN]", mainThread = true, id = 0, logfile = logfile})

--NOTE: "data/" is now default path for loadfile.

env.debug.logfile = logfile
env.args = args

--===== start initialisation =====--
log("Start initialization")
debug.setFuncPrefix("[INIT]")

dlog("Initialize main env")
local mainTable = loadfile("lua/core/mainTable.lua")()
for i, c in pairs(mainTable) do
	env[i] = c
end
env.version = version
env.args = args

--=== run dyn init ===--
log("Initialize core level")
env.dl.executeDir("lua/core/init", "INIT")

--=== load core files ===--
dlog("Initialize terminal")
loadfile(env.devConf.terminalPath .. "terminalManager.lua")(env)

loadfile("lua/core/shutdown.lua")(env)

--=== load dynamic data ===--

env.dl.load({
	target = env.commands, 
	dir = "userData/commands", 
	name = "commands",
})

log("Initialize system level")
env.dl.executeDir("lua/init", "INIT_SYSTEM")

log("Initialize user level")
env.dl.executeDir("userData/init", "INIT_USER")

log("Initialization done")

return true, env, shared