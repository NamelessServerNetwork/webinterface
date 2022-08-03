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
				
				[49] = { --f1
					
				},
				[50] = { --f2
					
				},
				[51] = { --f3
					
				},
				[52] = { --f4
					
				},
				[53] = { --f5
					
				},
				[55] = { --f6
					
				},
				[56] = { --f7
					--[126] = "EVENT_sqliteTest1_L",
					--[126] = "EVENT_sharedTest",
					[126] = "EVENT_userTest",
				},
				[57] = { --f8
					[126] = "EVENT_reloadHttpServerCallback",
				},
				
			},
			[52] = {
				[126] = "end",
			},
			[50] = {
				[126] = "insert",
				
				[48] = { --f9
					[126] = "RELOAD_COMMANDS",
				},
				[49] = { --f10
					[126] = "RELOAD_USER",
				},
				[51] = { --f11
					[126] = "RELOAD_SYSTEM",
				},
				[52] = { --f12
					[126] = "RELOAD_CORE",
				},
				
			},
			[51] = {
				[126] = "delete",
			},
			[53] = {
				[126] = "pageup",
			},
			[54] = {
				[126] = "pagedown",
			},
		},
	},
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