log("--===== Event controll thread start =====--")

local test1 = function(data) 
	print("TEST: " .. env.ut.tostring(data)) 
end

local test2 = function(data) 
	print("TEST2: " .. env.ut.tostring(data)) 
end

env.event.listen("TEST", test1)
env.event.listen("TEST2", test2)
