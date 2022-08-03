local devConf, args = ...

local path, logfile
local original = {}
local stdoutMetatable = getmetatable(io.stdout) --same table as for io.stderr.

original.stdWrite = stdoutMetatable.__index.write
original.ioWrite = io.write
original.print = print

local function seperatePath(path) --Ripped out of UT v0.8.4. (./data/lua/libs/UT.lua)
	if string.sub(path, #path) == "/" then
		return path
	end
	
	local dir, fileName, fileEnd = "", "", nil
	local tmpLatest = ""
	for s in string.gmatch(tostring(path), "[^/]+") do
		tmpLatest = s
	end
	dir = string.sub(path, 0, #path -#tmpLatest)
	for s in string.gmatch(tostring(tmpLatest), "[^.]+") do
		fileName = fileName .. s
		tmpLatest = s
	end
	if fileName == tmpLatest then
		fileName = tmpLatest
	else
		fileEnd = "." .. tmpLatest
		fileName = string.sub(fileName, 0, #fileName - #fileEnd +1)
	end
	
	return dir, fileName, fileEnd
end

path = seperatePath(devConf.debug.logfile)
os.execute("mkdir -p " .. path)
logfile = io.open(devConf.debug.logfile, "w")

return logfile, original

