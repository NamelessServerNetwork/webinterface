log("Starting HTTP test")

local http_server = require "http.server"
local http_headers = require "http.headers"

local port = 8006 -- 0 means pick one at random

local function getFunc(path)
	local suc, err = loadfile(path)
	local func
	
	if suc == nil then
		err(suc, err)
		return nil
	end
	func = suc(env, shared)
	if type(func) ~= "function" then
		err(func)
		return nil
	end
	return func
end

log("Initialize HTTP server")

local myserver = assert(http_server.listen {
	host = "0.0.0.0";
	port = port;
	onstream = getFunc("lua/threads/test/http/serverCallback2.lua");
	onerror = function(myserver, context, op, err, errno) -- luacheck: ignore 212
		local msg = op .. " on " .. tostring(context) .. " failed"
		if err then
			msg = msg .. ": " .. tostring(err)
		end
		assert(io.stderr:write(msg, "\n"))
	end;
})

-- Manually call :listen() so that we are bound before calling :localname()
assert(myserver:listen())
do
	local bound_port = select(3, myserver:localname())
	assert(io.stderr:write(string.format("Now listening on port %d\n", bound_port)))
end

log("Set listeners")
env.event.listen("reloadHttpServerCallback", function() 
	log("Relaod HTTP server callback")
	local newCallback = getFunc("lua/threads/test/http/serverCallback2.lua") 
	if newCallback == nil then
		err("Cant load new HTTP server callback")
	else
		myserver.onstream = newCallback
		log("Sucsesfully reloaded HTTP server callback")
	end
end)

local function update()
	assert(myserver:step(1))
	--print("HTTP: " .. tostring(env.getThreadInfos().id))
end
