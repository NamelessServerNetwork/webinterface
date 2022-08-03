local env, shared = ...

if env.devConf.onReload.core then
	dlog("Re init core")

	_G.loadfile = env.org.loadfile

	local _, newEnv, newShared = loadfile("data/lua/core/init.lua")(env.version, env.args)
	
	newEnv.oldEnv = env
	
	env.dl.setEnv(newEnv, newShared)
end