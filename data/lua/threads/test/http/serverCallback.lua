local http_headers = require "http.headers"

return function(myserver, stream) -- luacheck: ignore 212
	-- Read in headers
	local req_headers = assert(stream:get_headers())
	local req_method = req_headers:get ":method"
	
	-- Log request to stdout
	assert(io.stdout:write(string.format('[%s] "%s %s HTTP/%g"  "%s" "%s"\n',
		os.date("%d/%b/%Y:%H:%M:%S %z"),
		req_method or "",
		req_headers:get(":path") or "",
		stream.connection.version,
		req_headers:get("referer") or "-",
		req_headers:get("user-agent") or "-"
	)))
	
	print("==================")
	
	for i, c in stream:each_chunk() do
		log(i, c)
	end
	
	print("==================")
	
	dlog(req_method)
	
	print("==================")
	
	for i, c in req_headers:each() do
		dlog(i, c)
	end

	-- Build response headers
	local res_headers = http_headers.new()
	res_headers:append(":status", "200")
	res_headers:append("content-type", "text/plain")
	-- Send headers to client; end the stream immediately if this was a HEAD request
	assert(stream:write_headers(res_headers, req_method == "HEAD"))
	if req_method ~= "HEAD" then
		-- Send body, ending the stream
		stream:write_chunk("Hello world!\n")
		stream:write_chunk("whaaaass uppp?!!?!\n")
		stream:write_chunk("test3 \n")
		
		
		stream:write_chunk("", true)
	end
end