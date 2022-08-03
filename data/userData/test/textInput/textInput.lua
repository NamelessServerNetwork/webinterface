--ToDo: replace string.len with utf8.len when avaiable.

--===== require libs =====--
local getch = require("getch")
local textInput = loadfile("class.lua")()
local constants = require("terminalConstants")

--===== set constants =====--
local terminalSizeRefreshTime = 1

local ansi = constants.ansi
local keyTable = constants.keyTable

--===== set local variables =====--
local writeCursorPos = 1
local terminalLength, terminalHeight = 0, 0
local previusTerminalSizeRefreshTime = 0

local textBox = textInput.new()

--===== set local functions =====--
local function w(...)
	io.write(...)
end

local function getTerminalSize()
	local timeSeconds = os.time(os.date("*t"))
	if previusTerminalSizeRefreshTime + terminalSizeRefreshTime < timeSeconds then
		_, _, terminalLength = os.execute("return $(tput cols)")
		_, _, terminalHeight = os.execute("return $(tput lines)")
		previusTerminalSizeRefreshTime = timeSeconds
	end
	
	return terminalLength, terminalHeight
end

local function resetCursor()
	local terminalLength, terminalHeight = getTerminalSize()
	local _, cursorPos = textBox:get(terminalLength)
	
	w(ansi.setCursor:format(terminalHeight, cursorPos))
end

local function write(...) --io.write() replacement
	local _, terminalHeight = getTerminalSize()
	
	w(ansi.setCursor:format(terminalHeight -1, writeCursorPos))
	
	for _, arg in pairs({...}) do
		writeCursorPos = writeCursorPos + string.len(tostring(arg))
	end
	
	w(...)
	resetCursor()
end

local function print(...)
	local _, terminalHeight = getTerminalSize()
	w(ansi.setCursor:format(terminalHeight -1, writeCursorPos))
	w(...)
	writeCursorPos = 1
	resetCursor()
	w(ansi.clearLine)
	w("\n")
end

local function get_mbs(callback, keyTable, max_i, i)
	assert(type(keyTable)=="table")
	i = tonumber(i) or 1
	max_i = tonumber(max_i) or 10
	local key_code = callback()
	if i>max_i then
		return key_code, false
	end
	local key_resolved = keyTable[key_code]
	if type(key_resolved) == "function" then
		key_resolved = key_resolved(callback, key_code)
	end
	if type(key_resolved) == "table" then
		-- we're in a multibyte sequence, get more characters recursively(with maximum limit)
		return get_mbs(callback, key_resolved, max_i, i+1)
	elseif key_resolved then
		-- we resolved a multibyte sequence
		return key_code, key_resolved
	else
		-- Not in a multibyte sequence
		return key_code
	end
end

local function draw(text, cursorPos)
	local _, terminalHeight = getTerminalSize()
	w(ansi.setCursor:format(terminalHeight, 1))
	w(ansi.clearLine)
	w(text)
	resetCursor()
	io.flush()
end

--===== initialisation =====--
textBox.listedFunction = function(t)
	
end

--===== main while =====--
local c = 0
while true do
	local terminalLength = getTerminalSize()
	local code, action = get_mbs(getch.blocking, keyTable)
	
	textBox:update(terminalLength, code, action)
	
	draw(textBox:get(terminalLength))
end
