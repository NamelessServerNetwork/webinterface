print("THREAD START")

local timer = require("love.timer")
local socket = require("socket")

local client

local server = assert(socket.bind("192.168.1.208", 3344))
local ip, port = server:getsockname()

print(server, ip, port)

client = server:accept()

print("connected")

client:settimeout(10)

while true do
	local msg, err = client:receive()
	
	if msg ~= nil then
		print(msg, err)
	end
end
