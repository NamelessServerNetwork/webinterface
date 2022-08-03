-- reloads the main env. not affecting thread environments yet.

env.dl.load({
	target = env.dyn, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
	overwrite = true,
})

env.dl.load({ --legacy
	target = env, 
	dir = "lua/env/dynData", 
	name = "dynData", 
	structured = true,
	execute = true,
	overwrite = true,
})

for i, c in pairs(env._G) do
	_G[i] = c
end