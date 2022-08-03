local constants = {}

constants.keyTable = {
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
			[49] = {
				[126] = "pos1",
			},
			[52] = {
				[126] = "end",
			},
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

constants.ansi = {
	setCursor = "\027[%d;%dH",
	saveCursor = "\027[s",
	restoreCursor = "\027[u",
	cursorUp = "\027[1A",
	cursorDown = "\027[1B",
	clearLine = "\027[2K",
}

return constants