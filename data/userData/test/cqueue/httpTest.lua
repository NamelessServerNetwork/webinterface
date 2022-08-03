package.path = package.path .. ";" .. "/data/dams/data/lua/libs/?.lua;/data/dams/data/lua/libs/thirdParty/?.lua"
package.cpath = package.cpath .. ";" .. "/data/dams/data/bin/libs/?.so"


local port = 8011 -- 0 means pick one at random

local http_server = require "http.server"
local http_headers = require "http.headers"

local cqueues = require("cqueues")
--local cq = cqueues.new()

local function reply(myserver, stream) -- luacheck: ignore 212
	local http_server = require "http.server"
	local http_headers = require "http.headers"
	
	local req_headers = assert(stream:get_headers())
	local req_method = req_headers:get ":method"
	
	local function sleep(s)
		print("sleep: " .. tostring(s))
		local startTime = os.time()
		while os.time() < startTime + s do end
	end

	-- Log request to stdout
	assert(io.stdout:write(string.format('[%s] "%s %s HTTP/%g"  "%s" "%s"\n',
		os.date("%d/%b/%Y:%H:%M:%S %z"),
		req_method or "",
		req_headers:get(":path") or "",
		stream.connection.version,
		req_headers:get("referer") or "-",
		req_headers:get("user-agent") or "-"
	)))
	
	
	sleep(5)

	
	local res_headers = http_headers.new()
	res_headers:append(":status", "200")
	res_headers:append("content-type", "text/plain")
	assert(stream:write_headers(res_headers, false))
	assert(stream:write_chunk("Hello world!\n", true))
end

local function replyFunc(myserver, stream)
	local cq = cqueues.new()
	cq:wrap(reply, myserver, stream)
	cq:step(.1)
end

local myserver = assert(http_server.listen {
	host = "0.0.0.0";
	port = port;
	onstream = replyFunc;
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
-- Start the main server loop

myserver:loop()

--assert(myserver:loop())


print("END")





