local http_headers = require "http.headers"

local openStreams = {}
local _

local function callback(myserver, stream)
	log("Got user request from: ")	
	
	--=== create local variables ===--
	local callbackStream, callbackData
	
	local req_headers = assert(stream:get_headers())
	local requestData, headers = {}, {}

	--=== init ===--
	ldlog("Load headers")
	for index, value, neverIndex in req_headers:each() do
		headers[index] = {
			value = value, 
			neverIndex = neverIndex,
		}
	end

	requestData.headers = headers
	requestData.body = stream:get_body_as_string()

	ldlog("Start callback thread")
	local _, thr, id = env.startFileThread("lua/threads/httpServer/callbackThread.lua", "HTTP_CALLBACK_THREAD", requestData)
	callbackStream = env.thread.getChannel("HTTP_CALLBACK_STREAM#" .. tostring(id))

	--=== wait for callback thread to stop ===--
	ldlog("Wait for callback thread to stop")
	while thr:isRunning() do env.cqueues.sleep(.1) end
	callbackData = callbackStream:pop()
	
	--=== build response headers ===--
	ldlog("Building headers")
	local res_headers = http_headers.new()
	if not callbackData.headers[":status"] then
		res_headers:append(":status", "200")
	end
	--res_headers:append("content-type", "lua table")
	for i, c in pairs(callbackData.headers) do
		if type(c) == "string" or type(c) == "number" then
			res_headers:append(i, tostring(c))
		end
	end

	if callbackData.cookies then
		for name, value in pairs(callbackData.cookies) do
			res_headers:append("set-cookie", tostring(name) .. "=" .. tostring(value))
		end
	end

	stream:write_headers(res_headers, false)
	
	--=== send data ===--
	ldlog("Sending data")
	--stream:write_chunk(env.serialization.dump(callbackData.data)) --not needed anymore soon.
	stream:write_chunk(callbackData.data)
	stream:write_chunk("", true)
end

return function(myserver, stream)
	callback(myserver, stream)
end













