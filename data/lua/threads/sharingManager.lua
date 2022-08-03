--BUG: subtables from a locked table are still writable.

log("Starting sharing manager")

local sharedData = {
	
	t1 = {
		t2 = {
			ts = "test",
			tn = 3,
		},

		st1 = {
			ts = "sub test",
		},

		testValue = "TEST",
	},
	
} --all shared data
local lockTable = {locks = {}}

local _internal = {}

local responseChannels = {}
local requestChannel = env.thread.getChannel("SHARED_REQUEST")
local requestIDChannel = env.thread.getChannel("SHARED_CURRENT_REQUEST_ID")

local ldlog = debug.sharingThread
local generateIndexString = getmetatable(env.shared)._internal.generateIndexString

--===== local functions =====--
local function getValue(source, indexTable)
	local value = source
	local originValue = source

	for _, index in ipairs(indexTable) do
		if type(value) == "table" then
			originValue = value
			value = value[index]
		else
			return nil
		end
	end

	return value, originValue
end

local function getLock(indexString)
	for key, lock in pairs(lockTable.locks) do
		local indexStringIterator = string.gmatch(indexString, "[^.]+") 
		local keyStringIterator = string.gmatch(key, "[^.]+") 

		while true do
			local indexStringPart = indexStringIterator()
			local keyStringPart = keyStringIterator()

			if indexStringPart == nil or keyStringPart == nil then
				return lock
			elseif indexStringPart ~= keyStringPart then
				break
			end
		end
	end
end

local function isLocked(indexString, request)
	local lock = getLock(indexString)

	if request.bypassLock == true then
		warn("Thread: " .. tostring(request.threadID) .. " bypasses lock: '" .. indexString .. "'; requestID: " .. tostring(request.requestID))
		return false, lock
	end

	if lock ~= nil and lock.locked and lock.threadID ~= request.threadID then
		return true, lock
	else
		return false, lock
	end
end

--===== internal functions =====--
function _internal.execRequest(request)
	if request ~= nil then
		if responseChannels[request.threadID] == nil then
			os.execute("echo " .. request.threadID .. " > tt")
			responseChannels[request.threadID] = env.thread.getChannel("SHARED_RESPONSE#" .. tostring(request.threadID))
		end

		if request.request == "get" then
			if env.devConf.debug.logLevel.sharingThread then --double check to prevent string concatenating process if debug output is disabled.
				ldlog("GET request (CID: " .. tostring(request.threadID) .. "); index: '" .. generateIndexString(request.indexTable) .. "' requestID: " .. tostring(request.requestID))
			end

			local returnValue = getValue(sharedData, request.indexTable)

			if type(returnValue) == "table" then
				returnValue = {
					address = tostring(returnValue),
				}
			end

			responseChannels[request.threadID]:push(returnValue)
		elseif request.request == "set" then
			local indexString = generateIndexString(request.indexTable) .. "." .. tostring(request.index)
			local locked, lock

			if string.sub(indexString, 0, 1) == "." then --remove dot at the beginning of the indexString if present
				indexString = string.sub(indexString, 2)
			end

			if env.devConf.debug.logLevel.sharingThread then --double check to prevent string concatenating process if debug output is disabled.
				ldlog("SET request (CID: " .. tostring(request.threadID) .. "); index: " .. indexString .. "; new value: '" .. tostring(request.value) .. "' requestID: " .. tostring(request.requestID))
			end

			locked, lock = isLocked(indexString, request)
			if locked then
				ldlog("Index is locked. Add SET request to queue: (CID: " .. tostring(request.threadID) .. "); index: " .. indexString .. "; requestID: " .. tostring(request.requestID))
				table.insert(lock.execQueue, request)
			else
				local target = getValue(sharedData, request.indexTable)
				target[request.index] = request.value		
				responseChannels[request.threadID]:push(true)
			end
		elseif request.request == "call" then
			_internal.execCallRequest(request)
		elseif request.request == "dump" then
			log("Dumping shared table:\n" .. env.tostring(sharedData))
		elseif request.request == "dump_lockTable" then
			log("Dumping lockTable:\n" .. env.tostring(lockTable))
		elseif request.request == "stop" then --debug
			ldlog("Stop sharing manager")
			env.stop()
		end
	end
end

function _internal.execCallRequest(request)
	ldlog("Executing call order: " .. request.order .. "; thread: " .. tostring(request.threadID) .. "; requestID: " .. tostring(request.requestID))

	local success, returnTable = false, {}

	if request.order == "test" then
		log("Sharing table test call; requestID: " .. tostring(request.requestID))
		success = true
	elseif request.order == "dump" then
		log("Dumping shared table: '" .. generateIndexString(request.indexTable) .. "': " .. env.tostring(getValue(sharedData, request.indexTable)) .."; requestID: " .. tostring(request.requestID))
		success = true
	elseif request.order == "get" then
		returnTable.value = getValue(sharedData, request.indexTable)
		success = true
	elseif request.order == "lock" then
		local indexString = generateIndexString(request.indexTable)
		local locked, lock = isLocked(indexString, request)

		if locked then
			ldlog("Index is locked. Add lock request to queue: (CID: " .. tostring(request.threadID) .. "); index: " .. indexString .. "; requestID: " .. tostring(request.requestID))
			table.insert(lock.execQueue, request)
			return true
		end

		if lockTable.locks[indexString] == nil then
			lockTable.locks[indexString] = {
				execQueue = {},
			}
		end
		lockTable.locks[indexString].locked = true
		lockTable.locks[indexString].threadID = request.threadID

		success = true
	elseif request.order == "unlock" then
		local indexString = generateIndexString(request.indexTable)
		--local lock = lockTable.locks[indexString]
		local locked, lock = isLocked(indexString, request)

		if lock ~= nil then
			if locked then
				warn("Unpermittet thread (" .. tostring(request.threadID) .. ") tries to unlock table: '" .. indexString .. "'. Add unlock request to execQueue; requestID: " .. tostring(request.requestID))
				table.insert(lock.execQueue, request)
				return true
			else
				ldlog("Unlock table: '" .. indexString .. "'; thread: " .. tostring(request.threadID) .. "; requestID: " .. tostring(request.requestID))

				lock.locked = nil
				lock.threadID = nil

				ldlog("Execute queued requests for: '" .. indexString .. "'; requestID: " .. tostring(request.requestID))

				while lock.execQueue[1] ~= nil do
					local queuedRequest
					if lock.locked then
						break
					end
					queuedRequest = lock.execQueue[1]
					table.remove(lock.execQueue, 1)
					if lock.execQueue[1] == nil and lock.locked ~= true then
						lockTable.locks[indexString] = nil
					end
					_internal.execRequest(queuedRequest)
				end
			end

			success = true
		else
			returnTable.error = "Lock not found: '" .. indexString .. "'"
			success = false
		end
	else
		returnTable.error = "No valid order"
	end
	if not success then
		warn("Could not successfully execute call order: " .. request.order .. "; thread: " .. tostring(request.threadID) .. "; requestID: " .. tostring(request.requestID) .. "; error: \"" .. env.tostring(returnTable.error) .. "\"\nFull returnTable: ".. env.tostring(returnTable) .. "\nFull order request: " .. env.tostring(request))
	end
	returnTable.success = success
	responseChannels[request.threadID]:push(returnTable)
end

local function update()
	local request = requestChannel:demand(1)
	
	_internal.execRequest(request)
end

--===== init =====--
while requestIDChannel:pop() ~= nil do end
requestIDChannel:push(0)
