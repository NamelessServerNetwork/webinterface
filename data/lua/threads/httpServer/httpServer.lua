if not env.devConf.http.startHTTPServer then return true end
run = nil


log("Initialize HTTP server")

local httpServer = require("http.server")
local pkey = require("openssl.pkey")
local x509 = require("openssl.x509")

local port = 8023 -- 0 means pick one at random

local ctx
local cert = env.lib.ut.readFile(env.devConf.http.certPath)
local privateKey = env.lib.ut.readFile(env.devConf.http.privateKeyPath)
local forceTLS

env.httpCQ = {lastID = 0}

--env.httpCQ = env.cqueues.new()

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

do --setup TLS by using given cert/privatekey.
	if type(cert) == "string" and type(privateKey) == "string" then
		dlog("Initialize certificate")
		ctx = require("http.tls").new_server_context()
		ctx:setCertificate(x509.new(cert))
		ctx:setPrivateKey(pkey.new(privateKey))
	else
		warn("No TLS certificate given. Falling back to self-signed certificate.")
	end

	if env.devConf.forceTLS then
		log("Force TLS on")
		forceTLS = true
	end
end


dlog("Create server object")
local myserver = httpServer.listen({
	--cq = env.httpCQ;
	host = "0.0.0.0";
	port = port;
	onstream = getFunc("lua/threads/httpServer/serverCallback.lua");
	onerror = function(myserver, context, op, err, errno) -- luacheck: ignore 212
		local msg = op .. " on " .. tostring(context) .. " failed"
		if err then
			msg = msg .. ": " .. tostring(err)
		end
		debug.err("HTTP SERVER ERROR:")
		debug.err(msg, "\n")
	end;
	tls = forceTLS,
	ctx = ctx,
})

dlog("Set server to listen")
myserver:listen()

if env.isDevMode() then
	dlog("Set event listeners")
	env.event.listen("reloadHttpServerCallback", function() 
		log("Relaod HTTP server callback")
		local newCallback = getFunc("lua/threads/httpServer/serverCallback.lua");
		if newCallback == nil then
			err("Cant load new HTTP server callback")
		else
			myserver.onstream = newCallback
			log("Sucsesfully reloaded HTTP server callback")
		end
	end)
end

do
	local bound_port = select(3, myserver:localname())
	log("Now listening on port " .. tostring(bound_port))
end

log("HTTP server initialization done")

local count = 0
local function update()
	local stopAtHighCount = false --debug
	if count > 3000 and stopAtHighCount then 
		fatal("too many counts")
	else
		assert(myserver:step(1))
	end
	
	count = count +1
	
	--print("T", os.time(), count)
end
