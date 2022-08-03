ldlog("CALLBACK THREAD START")

local callbackStream = env.thread.getChannel("HTTP_CALLBACK_STREAM#" .. tostring(env.getThreadInfos().id))

local responseHeaders = {}
local responseData = {success = false}
local responseDataString = "If you see this, something went terrebly wrong. Please contact a system administrator."

local requestData = env.initData.args

local requestFormatter, responseFormatter
local requestFormatterName, responseFormatterName
local requestFormatterPath, responseFormatterPath = "./userData/requestFormatters/", "./userData/responseFormatters/"

local canExecuteUserOrder = true
local userRequest

local function executeUserOrder(request)
	local func, err, requestedAction

	if type(request) ~= "table" then
		warn("Recieved invalid request: " .. tostring(request))
		responseData.error = "Invalid request format."
		return false
	else
		requestData.request = request
		requestedAction = request.action
	end
	
	if requestedAction ~= nil then
		func, err = env.dyn.getActionFunc("data/userData/actions/" .. requestedAction .. ".lua")
	end
	
	if type(func) == "function" then
		local logPrefix = env.debug.getLogPrefix()
		debug.setLogPrefix("[ACTION]")
		responseData.returnValue, responseHeaders = func(requestData)
		responseData.success = true
		debug.setLogPrefix(logPrefix)
	else
		warn("Recieved unknown user action request: " .. tostring(requestedAction))
		responseData.error = "Invalid user action: " .. err 
	end
end

local function loadFormatter(headerName, path)
	ldlog("Load " .. headerName .. " formatter, dir: " .. path)

	local formatter, suc, err

	if requestData.headers[headerName] ~= nil then
		local requestedFormatter = requestData.headers[headerName].value
		local pathString = path .. "/" .. requestedFormatter .. ".lua"
		local loveFSCompatiblePathString = string.sub(pathString, 3)--yes it is actually necessary to remove the './' infromt of the path...

		formatter, err = loadfile(pathString)

		if type(formatter) ~= "function" then
			if env.lib.fs.getInfo(loveFSCompatiblePathString) == nil then --only generates a easyer to understand error msg if the formatter is not existing.
				responseData.error = "Requestet " .. headerName .. " not found (" .. requestedFormatter .. ")"
				responseData.scriptError = err
				canExecuteUserOrder = false
				return 1, headerName .. " not found"
			end

			warn("Can't load requestet " .. headerName .. ": ".. requestedFormatter .. ", error: " .. err)
			responseData.error = "Can't load requestet " .. headerName .. " (" .. requestedFormatter .. ")"
			responseData.scriptError = err
			canExecuteUserOrder = false
			return 2, err
		else
			return formatter, requestedFormatter
		end
	else
		canExecuteUserOrder = false
		return 3, "No formatter specified"
	end
end

--dlog(requestData.headers[":method"].value)
--dlog(requestData.body)

env.cookie.current = env.dyn.getCookies(requestData)

if requestData.headers[":method"].value == "GET" then
	local logPrefix = env.debug.getLogPrefix()
	debug.setLogPrefix("[SITE]")
	_, responseDataString, responseHeaders = env.dyn.execSite(requestData.headers[":path"].value, requestData)
	debug.setLogPrefix(logPrefix)
else
	do --formatting user request
		local suc
		local logPrefix

		if requestData.headers[":method"].value == "POST" then
			requestData.headers["request-format"] = {value = "HTML"}
			requestData.headers["response-format"] = {value = "HTML"}
		end

		--load request formatter
		requestFormatter, requestFormatterName, errorCode = loadFormatter("request-format", requestFormatterPath)
		if requestFormatter == 1 then
			responseData.errorCode = -1001
		elseif requestFormatter == 2 then
			responseData.errorCode = -1011
		elseif requestFormatter == 3 then
			responseData.errorCode = -1005
		end

		--load response formatter
		responseFormatter, responseFormatterName = loadFormatter("response-format", responseFormatterPath)
		if responseFormatter == 1 then
			responseData.errorCode = -1002
		elseif responseFormatter == 2 then
			responseData.errorCode = -1012
		elseif responseFormatter == 3 then
			responseData.errorCode = -1006
		end

		--format user request using loaded requst formatter
		if canExecuteUserOrder then
			logPrefix = debug.getLogPrefix()
			debug.setLogPrefix("[REQUEST_FORMATTER][" .. requestFormatterName .. "]")
			suc, userRequest = xpcall(requestFormatter, debug.traceback, requestData.body)
			debug.setLogPrefix(logPrefix)

			if suc ~= true then
				warn("Failed to execute request formatter: " .. requestFormatterName .. "; " .. tostring(userRequest))
				responseData.error = "Request formatter returned an error."
				responseData.scriptError = tostring(userRequest)
				canExecuteUserOrder = false
			end
		else
			responseData.error = requestFormatterName
		end
	end

	--execute user order
	if canExecuteUserOrder then 
		local suc, err = xpcall(executeUserOrder, debug.traceback, userRequest)
		if suc ~= true then
			debug.err("Execute user order: ", suc, err)
			responseData.error = "User script crash"
			responseData.scriptError = tostring(err)
		end
	end

	do --debug
		if type(shared.requestCount) ~= "number" then
			shared.requestCount = 0
		end
		shared.requestCount = shared.requestCount +1
		responseData.requestID = tostring(shared.requestCount)
	end

	do --formatting response table
		--responseData = env.lib.serialization.dump(responseData) --placeholder
		local suc, responseString = false, "[Formatter returned no error value]"

		if type(responseFormatter) == "function" then
			suc, responseString = xpcall(responseFormatter, debug.traceback, responseData, requestData.headers)
		end

		if suc ~= true then
			local newResponseString = [[
Can't format response table. 
Formatter error: ]] .. tostring(responseString) .. [[ 
Falling back to human readable lua-table.
			]] .. "\n"

			newResponseString = newResponseString .. env.lib.ut.tostring(responseData)
			responseDataString = newResponseString
		else
			responseDataString = responseString
		end
	end
end

if type(responseHeaders) ~= "table" then
	responseHeaders = {}
end

callbackStream:push({headers = responseHeaders, data = responseDataString, cookies = env.cookie.new})
env.cookie = {current = {}, new = {}}
ldlog("CALLBACK THREAD END")
env.stop()