#!/usr/bin/lua5.1
local getch = require("getch")

-- get the list of special keys
local function get_key_table()
	local key_table = {
		[10] = "enter",
		[9] = "tab",
		[127] = "backspace",
		[27] = {
			[27] = "escape",
			[91] = {
				[65] = "up",
				[66] = "down",
				[67] = "right",
				[68] = "left",
				[70] = "end",
				[72] = "pos1",
				[50] = {
					[126] = "insert"
				},
				[51] = {
					[126] = "delete"
				},
				[53] = {
					[126] = "pageup"
				},
				[54] = {
					[126] = "pagedown"
				}
			}
		}
	}

	-- add key combinations to key_table
	local exclude = {[3]=true, [9]=true, [10]=true, [13]=true, [17]=true, [19]=true, [26]=true}
	for i=1, 26 do
		if not exclude[i] then
			-- can't get these ctrl-codes via a terminal(e.g. ctrl-c)
			key_table[i] = "ctrl-"..string.char(i+96)
		end

		key_table[27][i+64] = "alt-"..string.char(i+96) -- e.g. alt-a
		key_table[27][i+96] = "alt-"..string.char(i+96) -- e.g. alt-shift-a
	end

	return key_table
end

-- get a key, and atempt to resolve a defined multibyte sequences (recursive).
local function get_mbs(callback, key_table, max_i, i)
	assert(type(key_table)=="table")
	i = tonumber(i) or 1
	max_i = tonumber(max_i) or 10
	local key_code = callback()
	if i>max_i then
		return key_code, false
	end
	local key_resolved = key_table[key_code]
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

-- returns true if a filepath exits(can be opened for reading), nil otherwise
local function file_exists(filepath)
	local f = io.open(filepath, "r")
	if f then
		f:close()
		return true
	end
end

-- splits a string into a table, sep is a single-character pattern to match the seperator.
-- see http://lua-users.org/wiki/SplitJoin
local function split_by_pattern(str,sep)
   local ret={}
   local n=1
   for w in str:gmatch("([^"..sep.."]*)") do
      ret[n] = ret[n] or w -- only set once (so the blank after a string is ignored)
      if w=="" then
         n = n + 1
      end -- step forwards on a blank but not a string
   end
   return ret
end

-- soft-wrap a line(split into multiple lines)
local function soft_wrap_line(line, len)
	return line:sub(1, len) -- TODO: wrap at words, insert newline for rendering, decrease view height, scroll_x
end

-- hard-wrap a line(scrollable)
local function hard_wrap_line(line, len, scroll_x)
	return line:sub(1+scroll_x, len+scroll_x)
end

-- return the whitespace used to "indent" this line
local function get_indent(str)
	return str:match("^%s*")
end

local function trim(str)
   local from = str:match("^%s*()")
   return (from > #str) and "" or str:match(".*%S", from)
end

-- ANSI terminal codes
-- luacheck: no unused
local fg_black = "\027[30m"
local fg_red = "\027[31m"
local fg_green = "\027[32m"
local fg_yellow = "\027[33m"
local fg_blue = "\027[34m"
local fg_magenta = "\027[35m"
local fg_cyan = "\027[36m"
local fg_white = "\027[37m"
local bg_black = "\027[40m"
local bg_red = "\027[41m"
local bg_green = "\027[42m"
local bg_yellow = "\027[43m"
local bg_blue = "\027[44m"
local bg_magenta = "\027[45m"
local bg_cyan = "\027[46m"
local bg_white = "\027[47m"
local reset_sgr = "\027[0m"
local clear_screen = "\027[2J"
local reset_cursor = "\027[;H"
local alternate_on = "\027[?1049h"
local alternate_off = "\027[?1049l"
local reset_all = reset_sgr .. clear_screen .. reset_cursor
local set_cursor_fmt = "\027[%d;%dH"
-- luacheck: unused

-- list of buffers currently open
local buffers = {}

local unicode = true
local screen_h = 25
local screen_w = 80

local run = true
local mode = "editor"
local clipboard

-- output strings to the terminal(stderr) for graphics output
local function w(...)
	io.stderr:write(...)
end
local function flush() -- needs to match w()
	io.stderr:flush()
end

-- simple drawing routine using ANSI escape sequences
local function editor_draw(buffer, no_topline)
	-- TODO: no need to redraw these every time
	local lines = {
		"test1",
		"test2",
		"test3",
	}
	for _,line in ipairs(lines) do
		w(line, "\n")
	end

	w(set_cursor_fmt:format(1, 2))

	flush()
end

local function repl_draw()
	-- reset sgr, clear screen, set cursor to 1,1
	w(reset_all)

	w("REPL\n")
	--w(("="):rep(80),"\n")
	local max_h = 20
	local min_i = #repl_output_history-max_h
	for i,v in ipairs(repl_output_history) do
		if i>min_i then
			w(v,"\n")
		end
	end
	--w(("="):rep(80),"\n")
	w(">"..repl_line)
end



local function main()
	-- Enable alternative screen buffer
	w(alternate_on)

	while run do
		if mode == "editor" then
			w(reset_all)
			editor_draw()
		elseif mode == "repl" then
			repl_draw()
		elseif mode == "menu" then
			menu_draw()
		end
		getch.blocking()
	end
	
	-- TODO: Check for unsaved changes

	-- Disable alternative screen buffer
	w(alternate_off)

	-- make sure outstanding (escape sequence) characters are received
	flush()

end

-- main "event loop"
main()