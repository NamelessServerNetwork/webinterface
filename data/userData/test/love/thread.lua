local channel = ...
local timer = require("love.timer")
local sql = require("lsqlite3complete")

print(channel)

while true do
	local msg = channel:pop()
	
	if msg ~= nil then
		print("THREAD_MSG", msg)
	end
end