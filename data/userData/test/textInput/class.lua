local UT = require("UT")

--===== TextInput =====--
TextInput = {}
TextInput.__index = TextInput

function TextInput.new(args) --posX == [int], posY == [int], size == [int], args == {colors == [numTable], listedFunction == [function()], managed == [{update == [bool], draw == [bool], stop == [bool]}]}

	local this = setmetatable({}, TextInput)
	args = args or {}
	this.listedFunction = args.listedFunction or function() end
	this.autoCompFunction = args.autoCompFunction or function() end
	
	this.cfg_keepText = false
	this.cfg_maxHistoryLength = -1
	this.cfg_hiddenText = UT.parseArgs(args.hiddenText, false)
	
	this.cfg_inputMap = {forbidden = {}, allowed = {}}
	
	this.autoComplete = args.autoComplete or {}
	
	this.status = false
	this.text = ""
	this.stringPosition = 0
	this.cursorPosition = 1
	this.history = {}
	this.historyPosition = -1
	this.userInput = ""
	this.autoCompBase = "" --for auto complete
	this.autoCompPos = 1
	
	return this
end

function TextInput.update(this, length, code, action)
	local inputCheck = UT.inputCheck
	local function MoveCursor(c)
		if 0 +c > 0 then
			if this.cursorPosition +c > length and #this.text -this.stringPosition >= length then
				this.stringPosition = this.stringPosition +(c - (length - this.cursorPosition))
				this.cursorPosition = length
			elseif this.cursorPosition < length and this.cursorPosition <= #this.text then
				this.cursorPosition = this.cursorPosition +c
			end
		else
			if this.cursorPosition +c < 1 and this.stringPosition > 0 then
				this.stringPosition = this.stringPosition +c
				this.cursorPosition = 1
			elseif this.cursorPosition > 1 then
				this.cursorPosition = this.cursorPosition +c
			end
		end
	end
	local function RSC() --reset cursor
		this.cursorPosition = 1
		this.stringPosition = 0
	end
	local m = this.cfg_inputMap
	
	if code ~= nil then			
		if action == "enter" then
			if #this.history >= this.cfg_maxHistoryLength and this.cfg_maxHistoryLength ~= -1 and this.cfg_maxHistoryLength ~= 0 then
				for c = 1, this.cfg_maxHistoryLength, 1 do
					this.history[c] = this.history[c +1]
				end
				this.history[this.cfg_maxHistoryLength] = this.text
			elseif this.cfg_maxHistoryLength ~= 0 then
				table.insert(this.history, this.text)
			end
			this.historyPosition = -1
			local success, errorMsg = xpcall(this.listedFunction, debug.traceback, this)
			if success == false then
				--this.ocui.onError(this, errorMsg)
			end
			if this.cfg_keepText == false then
				this.text = ""
				this.autoCompBase = this.text
				RSC()
			end
		elseif action == "left" then
			MoveCursor(-1)
		elseif action == "right" then
			MoveCursor(1)
		elseif action == "pos1" then
			RSC()
		elseif action == "end" then
			RSC()
			MoveCursor(#this.text)
		elseif action == "backspace" then
			if #this.text > 0 and this.cursorPosition > 1 then
				local ct = UT.getChars(this.text)
				table.remove(ct, this.cursorPosition + this.stringPosition -1)
				this.text = UT.makeString(ct)
				if #this.text >= length -1 then
					this.stringPosition = this.stringPosition -1
				else
					MoveCursor(-1)
				end
				this.autoCompBase = this.text
			end
		elseif action == "delete" then
			if #this.text - (this.cursorPosition + this.stringPosition) >= 0 then
				local ct = UT.getChars(this.text)
				table.remove(ct, this.cursorPosition + this.stringPosition)
				this.text = UT.makeString(ct)
				this.autoCompBase = this.text
			end
		elseif action == "up" then
			if this.historyPosition == -1 and this.cfg_maxHistoryLength ~= 0 and #this.history > 0 then
				this.userInput = this.text
				this.historyPosition = #this.history
				this.text = this.history[this.historyPosition]
			elseif this.historyPosition > 1 then
				this.historyPosition = this.historyPosition -1
				this.text = this.history[this.historyPosition]
			end
			RSC()
			MoveCursor(#this.text)
			this.autoCompBase = this.text
		elseif action == "down" then
			if this.historyPosition < #this.history and this.historyPosition ~= -1 then
				this.historyPosition = this.historyPosition +1
				this.text = this.history[this.historyPosition]
			elseif #this.history > 0 then
				this.historyPosition = -1
				this.text = this.userInput
			end
			RSC()
			MoveCursor(#this.text)
			this.autoCompBase = this.text
		elseif action == "tab" then
			local clear = true
			
			local success, errorMsg = xpcall(this.autoCompFunction, debug.traceback, this)
			if success == false then
				--this.ocui.onError(this, errorMsg)
			end
			
			if this.autoCompBase ~= string.sub(this.text, 0, #this.autoCompBase) or this.autoCompBase == "" then
				this.autoCompBase = this.text
			end
			for i = this.autoCompPos, #this.autoComplete do
				this.autoCompPos = i +1
				--print(string.sub(this.autoComplete[i], 0, #this.autoCompBase))
				if this.autoCompBase == string.sub(this.autoComplete[i], 0, #this.autoCompBase) then
					this.text = this.autoComplete[i]
					clear = false
					break
				end
			end
			if this.autoCompPos > #this.autoComplete and clear and #this.autoComplete > 0 then
				this.autoCompPos = 1
				this.text = this.autoCompBase
			end
			RSC()
			MoveCursor(#this.text)
		elseif action == nil and inputCheck(m.forbidden, code) == false and #m.allowed == 0 or inputCheck(m.allowed, code) then
			--this.text = this.text .. string.char(key)
			local ct = UT.getChars(this.text)
			table.insert(ct, this.cursorPosition +this.stringPosition, string.char(code))
			this.text = UT.makeString(ct)
			MoveCursor(1)
			this.autoCompBase = this.text
		end
	end
end

function TextInput.get(this, lengtht)
	local function generateTexture(t)
		return {textureFormat = "OCGLT", version = "v0.1", drawCalls = {{"f", t[1]}, {"b", t[2]}, {0, 0, t[3]}}}
	end
	local text = this.text
	if this.cfg_hiddenText then
		text = UT.fillString("", #this.text, "*")
	end
	
	for c = #this.text, lengtht -1, 1 do
		text = text .. " "
	end
	if #this.text > lengtht -1 then
		local tm = #this.text - (lengtht -1)
		tm = tm - this.stringPosition 
		if tm > 0 then
			text = string.sub(this.text, this.stringPosition +1, -tm)
		else
			text = string.sub(this.text, this.stringPosition +1)
			text = text .. " "
		end
	end
	
	--draw text
	return text, this.cursorPosition
end

return TextInput



