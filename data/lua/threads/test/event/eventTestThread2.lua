log("--===== Event test thread #2 start =====--")

local count = 0

local function update()
	sleep(.5)
	
	env.event.push("TEST", {td = count})
	count = count +1
end

local function stop()
	print("WSTOPPPPPPPPPPPPPPPPPPP")
end