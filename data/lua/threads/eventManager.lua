log("Starting event manager")

local listeners = {}

local eventQueue = env.thread.getChannel("EVENT_QUEUE_MAIN")
local listnerRegistation = env.thread.getChannel("EVENT_LISTENER_REGISTRATION")

local function registrateNewListeners()
	while listnerRegistation:peek() ~= nil do
		local request = listnerRegistation:pop()
		
		if listeners[request.eventName] == nil then 
			listeners[request.eventName] = {}
		end
		
		if request.request == "listen" then
			edlog("Registrate new listener thread: " .. tostring(request.threadName) .. "(" .. tostring(request.threadID) .. ")" .. " for event: " .. request.eventName)
			listeners[request.eventName][request.threadID] = env.thread.getChannel("EVENT_QUEUE_THREAD#" .. tostring(request.threadID))
		elseif request.request == "ignore" then
			edlog("Ignore listener thread: " .. tostring(request.threadName) .. "(" .. tostring(request.threadID) .. ")" .. " for event: " .. request.eventName)
			listeners[request.eventName][request.threadID] = nil
		end
	end
end

local function newEvent()
	local request = eventQueue:demand(1)
	
	registrateNewListeners()
	
	if request ~= nil and listeners[request.eventName] ~= nil then
		edlog("Pushing event: " .. request.eventName)
		
		for i, c in pairs(listeners[request.eventName]) do
			edlog("Pushing event: " .. request.eventName .. " to thread: " .. tostring(i))
			c:push({eventName = request.eventName, data = request.data})
		end
	end
end

local function update()
	newEvent()
end