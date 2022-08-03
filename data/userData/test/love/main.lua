local thread, channel 


function love.load()
	print("LOAD")
	
	dofile("init.lua")
	
	--channel = love.thread.newChannel()
	
	--thread = love.thread.newThread("thread.lua")
	--thread:start(channel)
	
	--thread = love.thread.newThread("httpThread.lua")
	--thread:start(channel)
	
	--dofile("httpTest.lua")
	--dofile("libTest.lua")
	--dofile("encryptionTest.lua")
	--dofile("sqliteTest.lua")
	
	dofile("threadTest.lua")
end

function love.update(dt)

	
	--[[
	local msg = io.read("*line")
	
	channel:push({test = "t1", test2 = "t2"})
	
	if msg ~= nil then
		--print(msg)
	end
	]]
	os.exit(0)
end

function love.threaderror(thread, err)
	print(err)
end

function love.quit()
	print("QUIT")
end