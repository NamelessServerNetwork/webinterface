--pre initializes the env for all threads

local initData = ...
local env = {
	--threadName = initData.name,
	mainThread = initData.mainThread,
	initData = initData,
}
local _internal = {
	threadID = initData.id,
	threadName = initData.name,
	threadIsActive = true,
}
setmetatable(env, {_internal = _internal})
_G.env = env

if initData.mainThread == true then --makes the print funciton logging into the logfile until the terminal is initialized. wich then replaces the global print function and takes take about the logging.
	local orgPrint = print

	_G.print = function(...) --will be overwritten by terminal.lua.
		local msgString = ""
		orgPrint(...)
	
		for _, s in pairs({...}) do
			msgString = msgString .. tostring(s) .. "  "
		end

		initData.logfile:write(msgString .. "\n")
		initData.logfile:flush()
	end
end

--=== load devConf ===--
local devConf = loadfile("data/devConf.lua")()
env.devConf = devConf

package.path = devConf.requirePath .. ";" .. package.path
package.cpath = devConf.cRequirePath .. ";" .. package.cpath

--=== set debug ===--
env.debug = loadfile("data/lua/env/debug.lua")(devConf, tostring(_internal.threadName) .. "[ENV_INIT]")

--=== disable env init logs for non main threads ===--
if not env.mainThread and not env.devConf.debug.logLevel.threadEnvInit then
	debug.setSilenceMode(true)
end

--=== set environment ===--
dlog("Load coreEnv")
loadfile("data/lua/env/coreEnv.lua")(env, env.mainThread)

--NOTE: "data/" is default path from here on

dlog("Loading core libs")
env.fs = require("love.filesystem")
env.ut = require("UT")
env.dl = loadfile("lua/libs/dataLoading.lua")(env)

dlog("Initialize the environment")
debug.setLogPrefix(tostring(_internal.threadName))

env.dl.executeDir("lua/env/init", "envInit")

dlog("Load dynamic env data")

env.dyn = {}
env.dl.load({
	target = env.dyn, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
})

env.dl.load({ --legacy
	target = env, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
})

for i, c in pairs(env._G) do
	_G[i] = c
end

--env.dl.loadDir("lua/env/dynData/test", {}, "dynData")

--=== enable logs again ===--
debug.setSilenceMode(false)

return env, env.shared