log("--===== Event test thread #1 start =====--")

local c = 0

local f1 = function(data) 
	print("EFT1: " .. data.td) 
end
local f2 = function(data) 
	print("EFT2: " .. data.td) 
end

env.event.listen("TEST", f1)
env.event.listen("TEST", f2)

local function update()
	sleep(1)
	
	if c == 2 then
		env.event.ignore("TEST", f1)
	elseif c == 3 then
		env.event.ignore("TEST", f2)
	end
	
	c = c+1
end