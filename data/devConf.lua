local devConf = {
	userLoginDatabasePath = "users.sqlite3",
	
	requirePath = "data/lua/libs/?.lua;data/lua/libs/thirdParty/?.lua;/home/noname/.luarocks/share/lua/5.1/?.lua",
	cRequirePath = "data/bin/libs/?.so;/home/noname/.luarocks/lib/lua/5.1/?.so",
	terminalPath = "lua/core/terminal/",
	
	sleepTime = .1, --the time the terminal is waiting for an input. this affect the CPU time as well as the time debug messanges needs to be updated.
	terminalSizeRefreshDelay = 1,

	devMode = true,

	dateFormat = "%X",
	--dateFormat = "%Y-%m-%d-%H-%M-%S",

	http = {
		certPath = "cert/cert.pem",
		privateKeyPath = "cert/privatekey.pem",
		forceTLS = false,

		startHTTPServer = true,

		defaultRequestFormat = "lua-table",
		defaultResponseFormat = "lua-table",
	},

	session = {
		deleteExpiredSessions = true, --if true an expired session gets deletet if the system tryed to enter it.
		cleanupExpiredSessionsAtShutdown = true,  --if true expired sessions gets cleaned up on shutdown.
	},
	
	terminal = {
		commands = {
			forceMainTerminal = "_MT",
		},
		keys = { --char codes for specific functions
			enter = 10,
			autoComp = 9,
			
		},
		movieLike = false, --just for the lulz :)
		movieLikeDelay = .004,
	},
	
	sqlite = {
		busyWaitTime = .05, --defines the time the system waits every time the sqlite DB is busy.
	},
	
	onReload = {
		core = true,
	},
	
	debug = {
		logfile = "./logs/dams.log",

		logDirectInput = false,
		logInputEvent = false,
		
		logLevel = {
			debug = true,
			lowLevelDebug = false,
			threadDebug = false,
			threadEnvInit = false, --print env init debug from every thread.
			eventDebug = false,
			lowLevelEventDebug = false,
			sharingDebug = false,
			sharingThread = false,

			require = false,
			loadfile = false,

			dataLoading = true, --dyn data loading debug.
			dataExecution = true, --dyn data execution debug.
			lowDataLoading = false, --low level dyn data loading debug.
			lowDataExecution = false, --low dyn data execution debug.

			exec = false, --prints whats is executet in the shell. WARNING: if used wrong this can expose passwords in the logfile!
			user = true, --print User / login db actions.
		},
	},
}

return devConf
