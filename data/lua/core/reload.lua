local env, shared = ...

print("--===== RELOAD =====--")
debug.setFuncPrefix("[RELOAD]")

--loadfile("data/lua/core/init/test.lua")(env, shared)

env.dl.executeDir("lua/core/onReload", "RELOAD_CORE")
--env.dl.executeDir("lua/env/onReload", "RELOAD_ENV") --would have to be done for all individual environments.
--env.dl.executeDir("lua/onReload", "RELOAD_SYSTEM")
env.dl.executeDir("userData/onReload", "RELOAD_USER")