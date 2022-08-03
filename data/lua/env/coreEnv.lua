--default env for all threads.
local env, mainThread, originalIoFunctions = ...

env.org = {
	require = require,
	loadfile = loadfile,
	print = print,
	io = {
		write = io.write,
		flush = io.flush,
		stdoutMetatable = {
			write = getmetatable(io.stdout).write,
		},
	},
}

local orgRequire = require
local orgLoadfile = loadfile

env.debug.internal.ioWriteBuffer = ""

local thread = orgRequire("love.thread")
local debug_print = thread.getChannel("debug_print")

if not env.mainThread then --the main thread gets its own print function through the terminal. as well as an preinit print function through envInit.lua.
	_G.print = function(...)
		local msgs = ""
		for _, msg in pairs({...}) do
			msgs = msgs .. tostring(msg) .. "\t"
		end
		debug_print:push(msgs)
	end
end

_G.io.write = function(...)
	for _, msg in pairs({...}) do
		env.debug.internal.ioWriteBuffer = env.debug.internal.ioWriteBuffer .. tostring(msg)
	end
end

_G.io.flush = function()
	_G.print(env.debug.internal.ioWriteBuffer)
	env.debug.internal.ioWriteBuffer = ""
end

getmetatable(io.stdout).__index.write = function(...) --sets the index for all userdata.write functions! 
	local args = {...}
	local msgString = ""

	env.org.io.stdoutMetatable.write(...)

	if args[1] == io.stdout or args[1] == io.stderr then --BUG: the value gets protet to the terminal twice if the main thread writes to it. logfile is not affected.
		env.org.io.stdoutMetatable.write(args[1], "\n")

		table.remove(args, 1)

		for _, msg in pairs(args) do
			msgString = msgString .. tostring(msg)
		end
		_G.print(msgString)
	end
end

local function require(p)
	debug.setFuncPrefix("[REQUIRE]")
	env.debug.requireLog(tostring(p))
	return orgRequire(p)
end

local function loadfile(p)
	local func, err
	debug.setFuncPrefix("[LOADFILE]")
	env.debug.loadfileLog(tostring(p))
	func, err = orgLoadfile("data/" .. p)
	if func == nil then
		debug.err(func, err)
	end
	return func, err
end

_G.require = require
_G.loadfile = loadfile
