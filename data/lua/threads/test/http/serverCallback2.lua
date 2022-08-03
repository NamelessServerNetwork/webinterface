local http_headers = require "http.headers"

return function(myserver, stream) -- luacheck: ignore 212
	-- Read in headers
	local req_headers = assert(stream:get_headers())
	local req_method = req_headers:get ":method"
	
	print("==================")
	
	for i, c in stream:each_chunk() do
		log(i, c)
	end
	
	print("==================")
	
	for i, c in req_headers:each() do
		dlog(i, c)
	end

	-- Build response headers
	local res_headers = http_headers.new()
	res_headers:append(":status", "200")
	res_headers:append("content-type", "lua table")
	stream:write_headers(res_headers, false)
	
	-- Send data
	stream:write_chunk([[
return {
	t1 = "test1",
	t2 = "test2",
}
	]])
	
	stream:write_chunk("", true)
end