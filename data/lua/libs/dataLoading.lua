local env, shared = ...

local DL = {}
local pa = env.ut.parseArgs

local defaultFileCode = [[local env, shared = ...;]]

--===== lib functions =====--
local function loadDir(target, dir, logFuncs, overwrite, subDirs, structured, priorityOrder, loadFunc, executeFiles)
	local path = dir .. "/" --= env.shell.getWorkingDirectory() .. "/" .. dir .. "/"
	logFuncs = logFuncs or {}
	--local print = logFuncs.log or dlog
	local print = logFuncs.log or debug.dataLoadingLog
	--local warn = logFuncs.warn or warn
	local warn = logFuncs.warn or err
	local onError = logFuncs.error or err
	local loadedFiles = 0
	local failedFiles = 0
	
	subDirs = env.ut.parseArgs(subDirs, true)
	
	for _, file in pairs(env.fs.getDirectoryItems(path)) do
		local p, name, ending = env.ut.seperatePath(path .. file)
		
		--print(p)
		
		if name ~= "gitignore" and name ~= "gitkeep" then
			if env.fs.getInfo(path .. file).type == "directory" and subDirs then
				if structured then
					if target[string.sub(file, 0, #file)] == nil or overwrite then
						target[string.sub(file, 0, #file)] = {}
						local s, f = loadDir(target[string.sub(file, 0, #file)], dir .. "/" .. file, logFuncs, overwrite, subDirs, structured, priorityOrder, loadFunc, executeFiles)
						loadedFiles = loadedFiles + s
						failedFiles = failedFiles + f
					else
						onError("[DLF]: Target already existing!: " .. file .. " :" .. tostring(target))
					end
				else
					local s, f = loadDir(target, path .. file, logFuncs, overwrite, subDirs, structured, priorityOrder, loadFunc, executeFiles)
					loadedFiles = loadedFiles + s
					failedFiles = failedFiles + f
				end
			elseif target[name] == nil or overwrite then
				local debugString = ""
				if target[name] == nil then
					debugString = "Loading file: " .. dir .. "/" .. file .. ": "
				else
					debugString = "Reloading file: " .. dir .. "/" .. file .. ": "
				end
				
				local suc, err 
				if loadFunc ~= nil then
					suc, err = loadFunc(path .. file)
				else
					--suc, err = loadfile(path .. file)
					local filePath = "data/" .. path .. file
					local fileCode, fileErr = env.ut.readFile(filePath)
					local tracebackPathNote = filePath
					--print(path .. file)
					if fileCode == nil then
						suc, err = nil, fileErr
					else
						local cutPoint = select(2, string.find(tracebackPathNote, "env"))
						if cutPoint then
							tracebackPathNote = string.sub(tracebackPathNote, cutPoint + 2)
						end

						suc, err = loadstring("--[[" .. tracebackPathNote .. "]] " .. defaultFileCode .. fileCode)
					end
				end
				
				--target[name or string.sub(p, 0, #p -1)] = suc
				if priorityOrder then
					local order = 50
					for fileOrder in string.gmatch(name, "([^_]+)") do
						order = tonumber(fileOrder)
						break
					end
					if order == nil then
						order = 50
					end
					if target[order] == nil then
						target[order] = {}
					end
					target[order][name] = suc
				else
					target[name] = suc
					if executeFiles then
						if type(suc) == "function" then
							local suc, returnValue = xpcall(suc, debug.traceback, env, shared)
							if suc == false then
								warn("Failed to execute: " .. name)
								warn(returnValue)
							else
								target[name] = returnValue
							end
						end
					end
				end
				
				if suc == nil then 
					failedFiles = failedFiles +1
					warn("Failed to load file: " .. dir .. "/" .. file .. ": " .. tostring(err))
				else
					loadedFiles = loadedFiles +1
					debug.lowDataLoadingLog(debugString .. tostring(suc))
				end
			end
		end
	end
	return loadedFiles, failedFiles
end

local function load(args)
	local target = pa(args.t, args.target, {})
	local dir = pa(args.d, args.dir)
	local name = pa(args.n, args.name, args.dir)
	local structured = pa(args.s, args.structured)
	local priorityOrder = pa(args.po, args.priorityOrder)
	local overwrite = pa(args.o, args.overwrite)
	local loadFunc = pa(args.lf, args.loadFunc)
	local executeFiles = pa(args.e, args.execute, args.executeFiles, args.executeDir)
	
	local loadedFiles, failedFiles = 0, 0
	
	debug.dataLoadingLog("Loading dir: " .. dir .. " (" .. name .. ")")
	loadedFiles, failedFiles = loadDir(target, dir, nil, overwrite, nil, structured, priorityOrder, loadFunc, executeFiles)
	debug.dataLoadingLog("Successfully loaded files: " .. tostring(loadedFiles) .. " (" .. name .. ")")
	if failedFiles > 0 then
		warn("Failed to load " .. tostring(failedFiles) .. " (" .. name .. ")")
	end
	debug.dataLoadingLog("Loading dir done: " .. dir .. " (" .. name .. ")")
	return target
end

local function execute(t, dir, name, callback, callbackArgs)
	local executedFiles, failedFiles = 0, 0
	
	debug.dataExecutionLog("Execute: " .. dir .. " (" .. name .. ")")
	
	for order = 0, 100 do
		local scripts = t[order]
		if scripts ~= nil then
			for name, func in pairs(scripts) do
				debug.lowDataExecutionLog("Execute: " .. name .. " (" .. tostring(func) .. ")")
				local suc, err = xpcall(func, debug.traceback, env, shared)
				
				if suc == false then
					warn("Failed to execute: " .. name)
					warn(err)
					failedFiles = failedFiles +1
				else
					if callback ~= nil then 
						callback(err, name, callbackArgs)
					end
					executedFiles = executedFiles +1
				end
			end
		end
	end
	
	return executedFiles, failedFiles
end

local function loadDir(dir, target, name) --is this user or even done?
	name = name or ""
	debug.dataLoadingLog("Prepare loadDir execution: " .. name .. " (" .. dir .. ")")
	local scripts = load({
		target = {}, 
		dir = dir, 
		name = name, 
		priorityOrder = true,
		structured = true,
	})
	print("################################")
	print(env.ut.tostring(scripts))
	
	local function sortIn(value, orgName, args)
		local index = args.index
		local name = orgName
		local order = string.gmatch(name, "([^_]+)")()
		local target = args.target
		
		if tonumber(order) ~= nil then
			name = string.sub(name, #order +2)
		end
		
		--print("F", orgName, name, index, value, args)
		
		
		target[name] = value
	end
	
	execute(scripts, dir, name, sortIn, {target = target})
	
	local function iterate(toIterate)
		if type(toIterate) ~= "table" then return end
		
		for i, t in pairs(toIterate) do
			print(i, type(tonumber(i)))
			if tonumber(i) == nil and type(t) == "table" then
				print(i, t)
				
				if toIterate[i] == nil then
					toIterate[i] = {}
				end
				
				execute(t, dir, name, sortIn, {target = t})
			end
			iterate(t)
		end
	end
	iterate(scripts)
	
	print(env.ut.tostring(target))
end

local function executeDir(dir, name)
	name = name or ""
	debug.dataExecutionLog("Prepare executeDir execution: " .. name .. " (" .. dir .. ")")
	local scripts = load({
		target = {}, 
		dir = dir, 
		name = name, 
		priorityOrder = true,
	})
	
	local executedFiles, failedFiles = execute(scripts, dir, name)

	debug.dataExecutionLog("Successfully executed: " .. tostring(executedFiles) .. " files (" .. name .. ")")
	if failedFiles > 0 then
		warn("Failed to executed: " .. tostring(failedFiles) .. " (" .. name .. ")")
	end
	debug.dataExecutionLog("Executing done: " .. name .. " (" .. dir .. ")")
end

local function setEnv(newEnv, newShared)
	env = newEnv
	shared = newShared
end

--===== set functions =====--
--DL.loadData = loadData
DL.load = load
DL.loadDir = loadDir
DL.executeDir = executeDir
DL.setEnv = setEnv

return DL