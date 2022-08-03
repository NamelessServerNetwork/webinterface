local getch = require("getch")

-- ANSI terminal codes
local reset_sgr = "\027[0m"
local clear_screen = "\027[2J"
local reset_cursor = "\027[;H"
local alternate_on = "\027[?1049h"
local alternate_off = "\027[?1049l"
local reset_all = reset_sgr .. clear_screen .. reset_cursor
local set_cursor_fmt = "\027[%d;%dH"

local function w(...)
	io.stderr:write(...)
end

local function draw()
	w(set_cursor_fmt:format(1, 2))
	
	io.stderr:flush()
end


while true do
	
	
	draw()
end